# ENCODING: UTF-8

class ToolsController < ApplicationController
  require 'csv'
  require 'capture_stdout'

  def index
  end

  def import_do
    if params[:upload] and !params[:formation_id].blank?
    	
      # Enregistre le fichier localement
      file_with_path = Rails.root.join('public', 'tmp', params[:upload].original_filename)
      File.open(file_with_path, 'wb') do |file|
          file.write(params[:upload].read)
      end

      # capture output
      @stream = capture_stdout do
	  	@importes = @errors = 0	

	  	index = 0

		CSV.foreach(file_with_path, headers:true, col_sep:';', quote_char:'"', encoding:'iso-8859-1') do |row|
			index += 1
			puts "Ligne ##{index}"

			# Date;Heure début;Heure fin;Durée;UE;Intervenant;Intitulé
			int= row['Intervenant'] ? Intervenant.where("nom like ?", row['Intervenant'].split(' ').first).first : nil

			cours = Cour.new(debut:row['Date'] + " " + row['Heure debut'], 
							fin:row['Date'] + " " + row['Heure fin'], 
							formation_id: params[:formation_id], 
							ue:row['UE'], intervenant:int, nom:row['Intitule'] )
			
			if cours.valid? 
				puts "COURS VALIDE => #{cours.changes}"
				cours.save if params[:save] == 'true'
	        	@importes += 1
			else
				puts "!! COURS INVALIDE !! Erreur => #{cours.errors.messages} | Source: #{row}"
				puts
				puts cours.changes
				@errors += 1
			end
			puts "- -" * 80
			puts
		end
	  	puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
	  	puts

		puts "=" * 80
		puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
		puts "=" * 80
      end

      # save output            
      #@now = DateTime.now.to_s
      #File.open("public/Documents/Import_logements-#{@now}.txt", "w") { |file| file.write @out }
    else
      flash[:alert] = "Manque le fichier source ou la formation pour pouvoir lancer l'importation !"
      redirect_to action: 'import'
    end  
  end

  def import_intervenants
  end

  def import_intervenants_do
    if params[:upload]
    	
      # Enregistre le fichier localement
      file_with_path = Rails.root.join('public', 'tmp', params[:upload].original_filename)
      File.open(file_with_path, 'wb') do |file|
          file.write(params[:upload].read)
      end

      # capture output
      @stream = capture_stdout do
	  	@importes = @errors = 0	

	  	index = 0

		CSV.foreach(file_with_path, headers:true, col_sep:';', quote_char:'"', encoding:'iso-8859-1:UTF-8') do |row|
			index += 1
			puts "Ligne ##{index}"

			intervenant = Intervenant.new(nom:row['nom'], prenom:row['prénom'], email:row['email'], linkedin_url:row['linkedin_url'], linkedin_photo:row['linkedin_photo'])
			
			if intervenant.valid? 
				puts "Intervenant VALIDE => #{intervenant.changes}"
				intervenant.save if params[:save] == 'true'
	        	@importes += 1
			else
				puts "!! Intervenant INVALIDE !! Erreur => #{intervenant.errors.messages} | Source: #{row}"
				puts
				puts intervenant.changes
				@errors += 1
			end
			puts "- -" * 80
			puts
		end
	  	puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
	  	puts

		puts "=" * 80
		puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
		puts "=" * 80
      end

      # save output            
      #@now = DateTime.now.to_s
      #File.open("public/Documents/Import_logements-#{@now}.txt", "w") { |file| file.write @out }
    else
      flash[:alert] = "Manque le fichier source pour lancer l'importation !"
      redirect_to action: 'import_intervenants'
    end  
  end

  def import_utilisateurs
  end

  def import_utilisateurs_do
    if params[:upload] and !params[:formation_id].blank?
    	
      # Enregistre le fichier localement
      file_with_path = Rails.root.join('public', 'tmp', params[:upload].original_filename)
      File.open(file_with_path, 'wb') do |file|
          file.write(params[:upload].read)
      end

      # capture output
      @stream = capture_stdout do
	  	@importes = @errors = 0	

	  	index = 0

		CSV.foreach(file_with_path, headers:true, col_sep:';', quote_char:'"', encoding:'iso-8859-1:UTF-8') do |row|
			index += 1
			puts "Ligne ##{index}"

			generated_password = Devise.friendly_token.first(8)
			user = User.new(email:row['email'], password:generated_password, formation_id:params[:formation_id])

			UserMailer.welcome_email(user, generated_password).deliver if params[:save] == 'true'
			
			if user.valid? 
				puts "user VALIDE => #{user.changes}"
				user.save if params[:save] == 'true'
	        	@importes += 1
			else
				puts "!! user INVALIDE !! Erreur => #{user.errors.messages} | Source: #{row}"
				puts
				puts user.changes
				@errors += 1
			end
			puts "- -" * 80
			puts
		end
	  	puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
	  	puts

		puts "=" * 80
		puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
		puts "=" * 80
      end

      # save output            
      #@now = DateTime.now.to_s
      #File.open("public/Documents/Import_logements-#{@now}.txt", "w") { |file| file.write @out }
    else
      flash[:alert] = "Manque le fichier source ou la formation pour pouvoir lancer l'importation !"
      redirect_to action: 'import_utilisateurs'
    end  
  end


  def creation_cours
  end

  def creation_cours_do
	@start_date = Date.civil(params[:cours]["start_date(1i)"].to_i,
                         params[:cours]["start_date(2i)"].to_i,
                         params[:cours]["start_date(3i)"].to_i)

	@end_date = Date.civil(params[:cours]["end_date(1i)"].to_i,
                         params[:cours]["end_date(2i)"].to_i,
                         params[:cours]["end_date(3i)"].to_i)

  	@ndays = (@end_date - @start_date).to_i

	duree = params[:duree]

  	current_date = @start_date
  	@cours_créés = @erreurs = 0

  	# capture output
    @stream = capture_stdout do
	  	@ndays.times do
	  		wday = current_date.wday
	  		if (params[:lundi] and wday == 1) or (params[:mardi] and wday == 2) or (params[:mercredi] and wday == 3) or (params[:jeudi] and wday == 4) or (params[:vendredi] and wday == 5) or (params[:samedi] and wday == 6)

		  		debut = Time.zone.parse(current_date.to_s + " #{params[:cours]["start_date(4i)"]}:#{params[:cours]["start_date(5i)"]}")

		  		fin = eval("debut + #{duree}.hour")

		  		new_cours = Cour.new(debut:debut.utc, fin:fin, duree:duree, formation_id:params[:formation_id], intervenant_id:params[:intervenant_id])

		  		#puts "#{debut} | #{fin} | #{new_cours.debut}"

		  		if new_cours.valid?
		  			new_cours.save if params[:save] == 'true'
	  			  	@cours_créés += 1
			  		puts "[Création OK] #{I18n.l(new_cours.debut, format: :long)}-#{I18n.l(new_cours.fin, format: :heures_min)}  "
	  			else
	  				@erreurs += 1
			  		puts "[Erreur!] #{I18n.l(new_cours.debut, format: :long)}-#{I18n.l(new_cours.fin, format: :heures_min)}  "
	  			end
	  		end
	  		current_date = current_date + 1.day
	  	end
	  	puts
	  	puts "----------- Les modifications n'ont pas été enregistrées ---------------" unless params[:save] == 'true'
	  	puts
		puts "=" * 80
	  	puts "Création termninée | #{@cours_créés} créneaux_créés | #{@erreurs} erreurs"
		puts "=" * 80
	end  	
  end

end
