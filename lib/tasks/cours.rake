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
  task envoyer_liste_cours: :environment do
    start_day = Date.today.beginning_of_month + 1.month
    end_day   = Date.today.end_of_month + 1.month
    puts "Période du #{start_day} au #{end_day}"

    cours = Cour
              .where("debut BETWEEN (?) AND (?)", start_day, end_day)
              .where(etat: Cour.etats.values_at(:planifié, :confirmé))
              .order(:intervenant_id, :debut)

    puts "#{cours.count} cours trouvés"
    puts "- " * 50

    liste_des_cours_a_envoyer = []
    liste_des_gestionnaires = {}
    envoyes = 0

    intervenant = cours.first.intervenant
    formation = cours.first.formation

    cours.each do | c |
      if c.intervenant != intervenant
        puts "Intervenant: #{intervenant.nom} (##{intervenant.id})" 
        
        liste_des_gestionnaires.each do | formation, gest |
          puts "Formation: #{formation} / #{gest ? "Gestionnaire: #{gest}" : '?'}"
        end

        puts "Cours: #{liste_des_cours_a_envoyer}"  

        envoyes += 1 if envoyer_liste_cours_a_intervenant(intervenant, liste_des_cours_a_envoyer, liste_des_gestionnaires) 
        intervenant = c.intervenant
        liste_des_cours_a_envoyer = []
        liste_des_gestionnaires = {}

        puts "#-" * 50
      end

      if c.formation
        liste_des_gestionnaires[c.formation.nom] = c.formation.try(:user).try(:email)
      end

      liste_des_cours_a_envoyer << "#{I18n.l(c.debut.to_date, format: :day)} #{I18n.l(c.debut, format: :short)}-#{I18n.l(c.fin, format: :heures_min)} #{c.nom_ou_ue}"
    end

    # pour le dernier de la liste
    puts "Intervenant: #{intervenant.nom} (##{intervenant.id})" 
    puts "Cours: #{liste_des_cours_a_envoyer}"  
    envoyes += 1 if envoyer_liste_cours_a_intervenant(intervenant, liste_des_cours_a_envoyer, liste_des_gestionnaires)  
    puts "#-" * 50

    puts "* #{envoyes} mail(s) envoyé(s) *"
  end

  def envoyer_liste_cours_a_intervenant(intervenant, liste, gestionnaires)
    if intervenant.notifier? && !intervenant.email.blank?
      puts "Planning envoyé à: #{intervenant.email}"

      IntervenantMailer
              .notifier_cours_semaine_prochaine(intervenant, liste, gestionnaires)
              .deliver_now

      return true
    else
      puts "Manque le flag 'Notification?' ou l'adresse email => Planning pas envoyé !" 
      return false
    end
  end

end
