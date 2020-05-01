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
          data += [ generate_pdf_cell(c, show_comments) ]
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
  
      def generate_pdf_cell(c, show_comments)
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
  

end