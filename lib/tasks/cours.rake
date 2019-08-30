# ENCODING: UTF-8

namespace :cours do

  desc "TODO"
  task update_duree: :environment do
	Cour.where(duree:0).each do |cours|
	  	cours.update_attributes(duree:(cours.fin - cours.debut) / 60 / 60)
  	end
  end

  desc "Passer les cours J - 1 en état Confirmé vers l'état Réalisé"
  task update_etat_realises: :environment do
      Cour.where("DATE(debut)=?", Date.today - 1.day)
          .where(etat: Cour.etats[:confirmé])
          .update_all(etat: Cour.etats[:réalisé])
  end

  desc "Envoyer la liste des cours aux intervenants" 
  task :envoyer_liste_cours, [:draft] => :environment do |task, args|

    puts "MODE DRAFT" if args.draft

    start_day = Date.today.beginning_of_month + 1.month
    end_day   = Date.today.end_of_month + 1.month
    puts "Période du #{start_day} au #{end_day}"

    envoyes = 0

    Intervenant.all.each do |intervenant| 

      cours = Cour.where("debut BETWEEN (?) AND (?)", start_day, end_day)
                   .where(etat: Cour.etats.values_at(:planifié, :confirmé))
                   .where.not(intervenant_id: 445)
                   .where("intervenant_id = ? OR intervenant_binome_id = ?", intervenant.id, intervenant.id)

      if cours.any?
        puts "#{intervenant.nom_prenom} (##{intervenant.id})" 
                      
        liste_des_cours_a_envoyer = []
        liste_des_gestionnaires = {}

        cours.each do |c|
          intitulé_cours = "#{I18n.l(c.debut.to_date, format: :day)} #{I18n.l(c.debut.to_date)} #{I18n.l(c.debut, format: :heures_min)}-#{I18n.l(c.fin, format: :heures_min)} #{c.formation.nom}/#{c.nom_ou_ue}"
          liste_des_cours_a_envoyer << intitulé_cours
          if c.formation
            liste_des_gestionnaires[c.formation.nom] = c.formation.try(:user).try(:email)
          end
        end
        puts "#{liste_des_cours_a_envoyer.count} cours a envoyer: #{liste_des_cours_a_envoyer}"  

        liste_des_gestionnaires.each do | formation, gest |
          puts "Formation: #{formation} / #{gest ? "Gestionnaire: #{gest}" : '?'}"
        end

        unless args.draft
          envoyes += 1 if envoyer_liste_cours_a_intervenant(intervenant, liste_des_cours_a_envoyer, liste_des_gestionnaires) 
        end

        puts "#-" * 50
      end 
    end

    puts "* #{envoyes} mail(s) envoyé(s) *" unless args.draft
  end

  def envoyer_liste_cours_a_intervenant(intervenant, liste, gestionnaires)
    if intervenant.notifier? && !intervenant.email.blank?
      puts "OK => Planning envoyé à: #{intervenant.email}"

      IntervenantMailer
               .notifier_cours_semaine_prochaine(intervenant, liste, gestionnaires)
               .deliver_now

      return true
    else
      puts "!KO => Manque le flag 'Notification?' et/ou l'adresse email" 
      return false
    end
  end

end
