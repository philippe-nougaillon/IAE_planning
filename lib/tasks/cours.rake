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
    	Cour.where("DATE(debut)=?", Date.today - 1.day).where(etat:Cour.etats[:confirmé]).update_all(etat:Cour.etats[:réalisé])
  end

  desc "Envoyer la liste des cours aux intervenants" 
  task envoyer_liste_cours: :environment do
    start_day = Date.today.beginning_of_week + 1.week
    end_day   = Date.today.end_of_week + 1.week
    cours     = Cour
                  .where("debut BETWEEN (?) AND (?)", start_day, end_day)
                  .where(etat: Cour.etats.values_at(:planifié, :confirmé))
                  .order(:intervenant_id, :debut)

    liste_des_cours_a_envoyer = []
    intervenant = cours.first.intervenant

    envoyes = 0
    cours.each do |c|
      if c.intervenant != intervenant
        if intervenant.notifier? && !intervenant.email.blank?
          envoyes += 1
          puts "- Envoi mail à : '#{intervenant.nom_prenom}' @:#{intervenant.email}"

          liste_des_cours_a_envoyer.each do |c|
            puts c
          end

          IntervenantMailer
                  .notifier_cours_semaine_prochaine(intervenant, liste_des_cours_a_envoyer)
                  .deliver_now
        end

        intervenant = c.intervenant
        liste_des_cours_a_envoyer = []
      end

      liste_des_cours_a_envoyer << "#{I18n.l(c.debut.to_date, format: :day)} #{I18n.l(c.debut, format: :short)}-#{I18n.l(c.fin, format: :heures_min)} => #{c.formation.nom} - #{c.nom}"
    end
    puts "* #{envoyes} mail(s) envoyé(s) *"
  end

end
