class ExportPdf
    include Prawn::View
  
    # Taille et orientation du document par défaut
    # def document
    #     @document ||= Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
    # end

    def initialize
        @margin_down = 15
        @image_path =  "#{Rails.root}/app/assets/images/"
    end

    def export_liste_des_cours(cours, show_comments = false)
        data = [ ['Formation/Date', 'Heure', 'Durée', 'Intervenant', 'Binôme', 'UE', 'Intitulé', 'Obs'] ]
  
        formation = nil
        cours.includes(:intervenant, :formation).each do | c |
          if c.formation != formation
            data += [ ["<b><i><color rgb='6495ED'><font size='9'>#{c.formation.nom}</font></color></i></b>"] ]
            formation = c.formation
          end
          data += [ generate_liste_des_cours_cell(c, show_comments) ]
        end
  
        font "Courier"
        font_size 8
        table(data, 
                  header: true, 
                  column_widths: [130, 40, 40, 100, 90, 25, 90, 25], 
                  cell_style: { :inline_format => true })
  
  
        move_down 30
        font_size 6
        text "Liste au #{I18n.l(Date.today, format: :long)}"
      end
  
    def generate_liste_des_cours_cell(c, show_comments)
        [
          I18n.l(c.debut.to_date, format: :long),
          "#{I18n.l(c.debut, format: :heures_min)} #{I18n.l(c.fin, format: :heures_min)}",
          "#{"%1.2f" % c.duree} h", 
          c.intervenant.nom_prenom,
          c.intervenant_binome.try(:nom_prenom),
          c.try(:ue),
          "<font size='7'>#{c.nom_ou_ue}</font>",
          show_comments ? "<font size='6'>#{c.commentaires}</font>" : ''
        ] 
    end
  

    def export_etats_de_services(cours, intervenants, start_date, end_date)
        intervenant = intervenants.first

        cours_ids = cours.where(intervenant: intervenant).where("hors_service_statutaire IS NOT TRUE").joins(:formation).order("formations.code_analytique").pluck(:id)
        cours_ids << cours.where(intervenant_binome: intervenant).where("hors_service_statutaire IS NOT TRUE").joins(:formation).order("formations.code_analytique").pluck(:id)
        # todo: Flatten sur resultat requete et pas après
        cours_ids = cours_ids.flatten
        
        vacations = intervenant.vacations.where("date BETWEEN ? AND ?", start_date, end_date)
        responsabilites = intervenant.responsabilites.where("debut BETWEEN ? AND ?", start_date, end_date)
        
        cumul_hetd = cumul_vacations = cumul_resps = cumul_tarif = cumul_duree = 0 
        nbr_heures_statutaire = intervenant.nbr_heures_statutaire || 0
        cumul_eotp, cumul_eotp_durée = {}, {}

        data = [ ['Code','Dest. fi.','Date','Heure','Formation','Intitulé','Durée','CM/TD','Taux','HETD','Montant'] ]
 
        cours_ids.each do |id|
            c = Cour.find(id)
            cumul_duree += c.duree 
    
            if c.imputable?
                cumul_hetd += c.duree.to_f * c.HETD
                montant_service = c.montant_service.round(2)
                cumul_tarif += montant_service
                formation = Formation.unscoped.find(c.formation_id)
                eotp = formation.Code_Analytique_avec_indice(c)
                cumul_eotp.keys.include?(eotp) ? cumul_eotp[eotp] += montant_service : cumul_eotp[eotp] = montant_service
                cumul_eotp_durée.keys.include?(eotp) ? cumul_eotp_durée[eotp] += c.duree : cumul_eotp_durée[eotp] = c.duree
            end
    
            formation = Formation.unscoped.find(c.formation_id)

            data += [ [
                formation.Code_Analytique_avec_indice(c),
                formation.Code_Analytique_avec_indice(c).include?('DISTR') ? "101PAIE" : "102PAIE",
                I18n.l(c.debut.to_date),
                c.debut.strftime("%k:%M"),
                formation.abrg,
                "#{c.ue} #{c.nom_ou_ue}",
                c.duree.to_f,
                formation.nomTauxTD,
                c.Taux_TD,
                c.HETD,
                montant_service
                ] ]
        end    

        # Sous-total des Cours
        data += [ [   
            nil, nil, nil, nil, nil,
            "<i><b>#{cours_ids.count} cour.s au total</i></b>",
            cumul_duree,
            nil, nil,
            cumul_hetd,
            cumul_tarif
            ] ]


        # Vacations
        vacations.each_with_index do | vacation, index |
            montant_vacation = ((Cour.Tarif * vacation.forfaithtd) * vacation.qte).round(2)
            cumul_vacations += montant_vacation
            cumul_hetd += (vacation.qte * vacation.forfaithtd)
            formation = Formation.unscoped.find(vacation.formation_id) 
            
            data += [ [
                formation.Code_Analytique,
                formation.Code_Analytique.include?('DISTR') ? "101PAIE" : "102PAIE",
                I18n.l(vacation.date),
                nil,
                formation.nom,
                vacation.titre,
                vacation.qte,
                nil, nil,
                vacation.forfaithtd,
                montant_vacation
                ] ] 
    
            if index == vacations.size - 1
                data += [ [
                    nil, nil, nil, nil, nil,  
                    "<b><i>#{vacations.size} vacation.s au total</i></b>",
                    nil, nil, nil, nil,
                    cumul_vacations
                ] ]
            end
        end

        # Responsabilités
        responsabilites.each_with_index do |resp, index|
            montant_responsabilite = (resp.heures * Cour.Tarif).round(2)
            cumul_resps += montant_responsabilite
            cumul_hetd += resp.heures

            data += [ [
                resp.formation.Code_Analytique,
                resp.formation.Code_Analytique_avec_indice(c).include?('DISTR') ? "101PAIE" : "102PAIE",
                I18n.l(resp.debut),
                nil,
                resp.formation.nom,
                resp.titre,
                resp.heures,
                nil, nil, nil,
                montant_responsabilite
                ] ]

            if index == responsabilites.size - 1
                data += [ [
                    nil, nil, nil, nil, nil, nil, nil, nil, nil,
                    "#{responsabilites.count} responsabilité.s au total",
                    cumul_resps,
                    nil
                    ] ]
            end
        end


        # Grand TOTAL
        s = ""
        if nbr_heures_statutaire > 0
            s = "Nbr Heures Statutaires: #{nbr_heures_statutaire} h"
            if (nbr_heures_statutaire > 0) && (cumul_hetd >= nbr_heures_statutaire)
                s += "Dépassement: #{cumul_hetd - nbr_heures_statutaire} h"
            end
        end

        data += [ [nil, nil, nil, nil, nil, "<b><i>TOTAL #{s} </i></b>", nil, nil, nil, nil, cumul_resps + cumul_vacations + cumul_tarif] ]


        # Générer la Table
        font "Helvetica"
        font_size 7
        table(data, 
                  header: true, 
                  cell_style: { :inline_format => true })
  

        
    end






end