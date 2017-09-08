# ENCODING: UTF-8

namespace :cours do
  desc "TODO"
  task update_duree: :environment do
  	Cour.where(duree:0).each do |cours|
	  	cours.update_attributes(duree:(cours.fin - cours.debut) / 60 / 60)
  	end
  end

  desc "Passer les cours J - 1  en état Confirmé vers l'état Réalisé"
  task update_etat_realises: :environment do
    Cour.where("DATE(debut)=?", Date.today - 1.day).where(etat:Cour.etats[:confirmé]).update_all(etat:Cour.etats[:réalisé])
  end

end
