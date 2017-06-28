# ENCODING: UTF-8

class ToolsController < ApplicationController  
  include ActionView::Helpers::NumberHelper

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

        CSV.foreach(file_with_path, headers:true, col_sep:';', quote_char:'"', encoding:'iso-8859-1:UTF-8') do |row|
          index += 1

          # Date;Heure début;Heure fin;Durée;UE;Intervenant;Intitulé

          # passe si pas de valur dans la date
          next unless row['Date']
          
          intervenant = nil
          if row['Intervenant']
            nom = row['Intervenant'].strip.split(' ').first
            intervenant = Intervenant.where("nom like ?", "%#{nom}%").first
          end

          debut = Time.parse(row['Date'] + " " + row['Heure début'])
          fin   = Time.parse(row['Date'] + " " + row['Heure fin'])

          cours = Cour.where(debut:debut, formation_id: params[:formation_id]).first_or_initialize 
          cours.fin = fin
          cours.ue = row['UE']
          cours.intervenant = intervenant
          cours.nom = row['Intitulé']
          cours.duree = ((cours.fin - cours.debut) / 3600).round

          if cours.valid? 
            #puts "COURS VALIDE => #{cours.changes}" if cours.new_record?
            #puts "UPDATE =>#{cours.attributes}" unless cours.new_record?
            #puts "Durée: #{cours.duree.to_f}"
            cours.save if params[:save] == 'true'
                @importes += 1
          else
            puts "Ligne ##{index}"
            puts "COURS INVALIDE !! Erreur => #{cours.errors.messages} | Source: #{row}"
            puts
            # puts cours.changes
            @errors += 1
          end
          puts "- -" * 40
          puts
        end
        puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
        puts

        puts "=" * 40
        puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
        puts "=" * 40

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
  	  	@importes = @modifies = @errors = 0	

  	  	index = 0

    		CSV.foreach(file_with_path, headers:true, col_sep:';', encoding:'iso-8859-1:UTF-8') do |row|
    			index += 1

          intervenant = Intervenant.where("lower(nom) = ? AND email = ?", row['nom'].strip.downcase, row['email']).first_or_initialize

          intervenant.nom = row['nom'].strip.upcase 
          intervenant.prenom = row['prénom'].strip
          intervenant.email = row['email']
          intervenant.linkedin_url = row['linkedin_url']
          intervenant.titre1 = row['titre1']
          intervenant.titre2 = row['titre2']
          intervenant.status = row['status']
          intervenant.spécialité = row['spécialité']
          intervenant.téléphone_fixe = row['téléphone_fixe']
          intervenant.téléphone_mobile = row['téléphone_mobile']
          intervenant.bureau = row['bureau']

          unless intervenant.new_record?
            if intervenant.changes.any?
              puts "Intervenant '#{intervenant.nom}' MODIFIE => #{intervenant.changes}" 
              puts
              @modifies += 1
            end
          end

    			if intervenant.valid? 
            if intervenant.changes.any? and intervenant.new_record?
    				  puts "Intervenant '#{intervenant.nom}' AJOUTE => #{intervenant.changes}"
              puts
              @importes += 1
            end
  				  intervenant.save if params[:save] == 'true'
    			else
            puts "Ligne ##{index}"
            puts "!! Intervenant INVALIDE !! Erreur => #{intervenant.errors.messages} | Source: #{row}"
            puts
            # puts intervenant.changes
            puts "- -" * 40
            puts
    				@errors += 1
          end
    		end
    	  puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
    	  puts

    		puts "=" * 70
    		puts "Lignes traitées: #{index} | Lignes importées: #{@importes} | Lignes modifiées: #{@modifies} | Lignes ignorées: #{@errors}"
    		puts "=" * 70
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

			generated_password = Devise.friendly_token.first(12)
			user = User.new(email:row['email'], nom:row['nom'].strip, prénom:row['prénom'].strip, mobile:row['mobile'], 
							password:generated_password, formation_id:params[:formation_id])

			user.admin = true if row['admin?'] == 'admin'
			
			UserMailer.welcome_email(user, generated_password).deliver if params[:save] == 'true'
			
			if user.valid? 
				#puts "user VALIDE => #{user.changes}"
				user.save if params[:save] == 'true'
	        	@importes += 1
			else
				puts "Ligne ##{index}"
				puts "!! user INVALIDE !! Erreur => #{user.errors.messages} | Source: #{row}"
				puts
				# puts user.changes
				@errors += 1
			end
			puts "- -" * 40
			puts
		end
	  	puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
	  	puts

		puts "=" * 40
		puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
		puts "=" * 40
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
  	if params[:duree].blank?
      flash[:alert] = "Erreur... manque la durée"
      redirect_to action: 'creation_cours'
      return
    end 

	@start_date = Date.civil(params[:cours]["start_date(1i)"].to_i,
                         	 params[:cours]["start_date(2i)"].to_i,
                         	 params[:cours]["start_date(3i)"].to_i)

	@end_date = Date.civil(params[:cours]["end_date(1i)"].to_i,
                           params[:cours]["end_date(2i)"].to_i,
                           params[:cours]["end_date(3i)"].to_i)

  	current_date = @start_date
  	@ndays = (@end_date - @start_date).to_i + 1
	duree = params[:duree]
	salle_id = params[:salle_id]
	nom_cours = params[:nom]

  	@cours_créés = @erreurs = 0

  	# capture output
    @stream = capture_stdout do
	  	@ndays.times do
	  		wday = current_date.wday
	  		if (params[:lundi] and wday == 1) or (params[:mardi] and wday == 2) or (params[:mercredi] and wday == 3) or (params[:jeudi] and wday == 4) or (params[:vendredi] and wday == 5) or (params[:samedi] and wday == 6)

		  		debut = Time.zone.parse(current_date.to_s + " #{params[:cours]["start_date(4i)"]}:#{params[:cours]["start_date(5i)"]}")

		  		fin = eval("debut + #{duree}.hour")

		  		new_cours = Cour.new(debut:debut.utc, fin:fin, duree:duree, formation_id:params[:formation_id], intervenant_id:params[:intervenant_id], nom:nom_cours, salle_id:salle_id)

		  		if new_cours.valid?
		  			new_cours.save if params[:save] == 'true'
	  			  	@cours_créés += 1
			  		puts "[Création OK] #{I18n.l(new_cours.debut, format: :long)}-#{I18n.l(new_cours.fin, format: :heures_min)}  "
	  			else
	  				@erreurs += 1
			  		puts "[Erreur!] #{I18n.l(new_cours.debut, format: :long)}-#{I18n.l(new_cours.fin, format: :heures_min)}  | #{new_cours.errors.messages}"
	  			end
	  		end
	  		current_date = current_date + 1.day
	  	end
	  	puts
		puts "=" * 40
	  	puts "Création termninée | #{@cours_créés} créneaux_créés | #{@erreurs} erreurs"
		puts "=" * 40
	  	puts
	  	puts "----------- Les modifications n'ont pas été enregistrées ---------------" unless params[:save] == 'true'
	end  	
  end

  def export
  end

  def export_do
	@cours = Cour.includes(:formation, :intervenant, :salle).order(:debut)

    unless params[:start_date].blank? and params[:end_date].blank? 
      @start_date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date])

      @cours = @cours.where("cours.debut BETWEEN DATE(?) AND DATE(?)", @start_date, @end_date)
    end

    unless params[:formation_id].blank?
      @cours = @cours.where(formation_id:params[:formation_id])
    end

    unless params[:intervenant_id].blank?
      @cours = @cours.where(intervenant_id:params[:intervenant_id])
    end

    unless params[:etat].blank?
      @cours = @cours.where(etat:params[:etat])
    end

    require 'csv'

  	@csv_string = CSV.generate(col_sep:';', encoding:'iso-8859-1') do | csv |
      csv << ['id','date debut', 'heure debut', 'date fin','heure fin', 'formation_id','formation','intervenant_id','intervenant','nom du cours', 'etat','duree','cours cree le', 'cours modifie le']
      
      @cours.each do |c|
        fields_to_export = [c.id, c.debut.to_date.to_s, c.debut.to_s(:time), c.fin.to_date.to_s, c.fin.to_s(:time), 
          c.formation_id, c.formation.nom_promo, c.intervenant_id, c.intervenant.nom_prenom, c.nom, c.etat, 
          number_with_delimiter(c.duree, separator: ","), c.formation.Forfait_HETD, c.formation.Taux_TD, 
          c.formation.Code_Analytique, c.created_at, c.updated_at]
        
        csv << fields_to_export

        # exporter le binome sauf si l'utilisateur ne veut que les cours d'un intervenant 
        if c.intervenant_binome and !params[:intervenant_id]
          fields_to_export[7] = c.intervenant_binome_id
          fields_to_export[8] = c.intervenant_binome.nom_prenom 
          csv << fields_to_export
        end  
      end
    end
    
    filename = "Export_Cours_#{Date.today.to_s}"
    response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.csv"'
    render "export_do.csv.erb"

  end

  def export_intervenants
  end

  def export_intervenants_do
    require 'csv'

  	@csv_string = CSV.generate(col_sep:';', encoding:'iso-8859-1') do | csv |
      csv << ["id", "nom","prenom", "email", "status", "remise_dossier_srh", "linkedin_url", "titre1", "titre2", "spécialité", "téléphone_fixe", "téléphone_mobile", "bureau", "adresse", "cp", "ville",'cree le', 'modifie le' ]
      
      Intervenant.all.each do |c|
        fields_to_export = [c.id, c.nom, c.prenom, c.email, c.status, c.remise_dossier_srh, c.linkedin_url, c.titre1, c.titre2, c.spécialité, c.téléphone_fixe, c.téléphone_mobile, c.bureau, c.adresse, c.cp, c.ville, c.created_at, c.updated_at]
        
        csv << fields_to_export
      end
    end
    
    filename = "Export_Intervenants_#{Date.today.to_s}"
    response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.csv"'
    render "export_intervenants_do.csv.erb"
  end

end
