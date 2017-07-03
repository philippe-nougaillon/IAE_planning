namespace :cours do
  desc "TODO"
  task update_duree: :environment do
  	Cour.where(duree:0).each do |cours|
	  	cours.update_attributes(duree:(cours.fin - cours.debut) / 60 / 60)
  	end
  end

end
