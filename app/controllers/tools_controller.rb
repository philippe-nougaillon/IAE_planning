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

        index = 1

        CSV.foreach(file_with_path, headers:true, col_sep:';', quote_char:'"', encoding:'iso-8859-1:UTF-8') do |row|
          index += 1

          # Date;Heure début;Heure fin;Durée;UE;Intervenant;Intitulé

          # passe si pas de valeur dans le champs date
          next unless row['Date']
          
          intervenant = nil
          if row['Intervenant']
            nom = row['Intervenant'].strip.split(' ').first.upcase
            intervenant = Intervenant.where(nom:nom).first_or_initialize
            if intervenant.new_record?
              puts "Intervenant #{intervenant.nom} sera créé. Ne pas tenir compte du message intervenant_id doit être rempli."
              intervenant.prenom = row['Intervenant'].strip.split(' ').last
              intervenant.email = "?"
              intervenant.save if params[:save] == 'true'
            end
          end

          debut = Time.parse(row['Date'] + " " + row['Heure début'])
          fin   = Time.parse(row['Date'] + " " + row['Heure fin'])

          #cours = Cour.where(debut:debut, formation_id: params[:formation_id]).first_or_initialize 
          cours = Cour.new(debut:debut, formation_id:params[:formation_id])
          cours.fin = fin
          cours.ue = row['UE'].strip if row['UE']
          cours.intervenant = intervenant
          cours.nom = row['Intitulé']
          # puts "Durée 1: #{cours.duree.to_f}"
          
          cours.duree = ((cours.fin - cours.debut) / 3600)
          # puts "Durée 2: #{cours.duree.to_f}"
          
          if cours.valid? 
            #puts "COURS VALIDE => #{cours.changes}" if cours.new_record?
            #puts "UPDATE =>#{cours.attributes}" unless cours.new_record?
            #puts "Durée3: #{cours.duree.to_f}"
            cours.save if params[:save] == 'true'
            @importes += 1
          else
            puts "Ligne ##{index}"
            puts "COURS INVALIDE !! Erreur => #{cours.errors.messages} | Source: #{row}"
            puts
            # puts cours.changes
            @errors += 1
          end
          # puts "- -" * 40
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

  	  	index = 1

    		CSV.foreach(file_with_path, headers:true, col_sep:';', encoding:'iso-8859-1:UTF-8') do |row|
    			index += 1

          intervenant = Intervenant.where("lower(nom) = ? AND email = ?", row['nom'].strip.downcase, row['email']).first_or_initialize

          intervenant.nom = row['nom'].strip.upcase 
          intervenant.prenom = row['prénom'].strip
          intervenant.email = row['email']
          intervenant.linkedin_url = row['linkedin_url']
          intervenant.titre1 = row['titre1']
          intervenant.titre2 = row['titre2']
          intervenant.status = row['statut']
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
    authorize :tool, :import_utilisateurs?
  end

  def import_utilisateurs_do
    authorize :tool, :import_utilisateurs?
    
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
           
          if user.valid? 
            user.save if params[:save] == 'true'
            UserMailer.welcome_email(user.id, generated_password).deliver_later if params[:save] == 'true'
            
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


  def import_etudiants
  end

  def import_etudiants_do
    
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

          etudiant = Etudiant.new(nom:row['nom'].strip, prénom:row['prénom'].strip, 
                                  email:row['email'], mobile:row['mobile'], formation_id:params[:formation_id])
           
          if etudiant.valid? 
            etudiant.save if params[:save] == 'true'
            @importes += 1
          else
            puts "Ligne ##{index}"
            puts "!! étudiant INVALIDE !! Erreur => #{etudiant.errors.messages} | Source: #{row}"
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
      redirect_to action: 'import_etudiants'
    end  
  end

  def swap_intervenant
    authorize :tool, :swap_intervenant?
  end

  def swap_intervenant_do
    authorize :tool, :swap_intervenant?
    
    unless params[:intervenant_from_id].blank? and params[:intervenant_to_id].blank?
    	
      # capture output
      @stream = capture_stdout do
        @importes = @errors = 0	

        @cours = Cour.where(intervenant_id:params[:intervenant_from_id])

        puts "#{@cours.count} cours à modifier"

        if (@cours.any? and params[:save] == 'true') 
          @cours.update_all(intervenant_id:params[:intervenant_to_id])
          puts "les cours ont été modifiés !"
        end 
        
        puts 
        puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
        puts

        puts "=" * 40
        puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
        puts "=" * 40
      end

    else
      flash[:alert] = "Manque les intervenants afin de lancer la modification !"
      redirect_to action: 'swap_intervenant'
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

    @csv_string = Cour.generate_csv(@cours, !params[:intervenant_id])  
    filename = "Export_Cours_#{Date.today.to_s}"
    response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.csv"'
    render "export_do.csv.erb"

  end

  def export_intervenants
  end

  def export_intervenants_do
    require 'csv'

  	@csv_string = CSV.generate(col_sep:';', encoding:'UTF-8') do | csv |
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

  def etudiants
  end

  def export_etudiants_do
    require 'csv'

    @etudiants = Etudiant.all

    unless params[:formation_id].blank?
      @etudiants = @etudiants.where(formation_id:params[:formation_id])
    end

  	@csv_string = CSV.generate(col_sep:';', encoding:'UTF-8') do | csv |
      csv << ["id", "nom","prénom", "email", "mobile", "formation_id", "formation_nom","créé le", "modifié le"]
      
      @etudiants.all.each do |c|
        fields_to_export = [c.id, c.nom, c.prénom, c.email, c.mobile, c.formation_id, c.formation.nom, c.created_at, c.updated_at]
        
        csv << fields_to_export
      end
    end
    
    filename = "Export_Etudiants_#{Date.today.to_s}"
    response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.csv"'
    render "export_etudiants_do.csv.erb"
  end



  def etats_services
  end

  def etats_services_do

    unless params[:intervenant_id].blank? 
      @intervenant = Intervenant.find(params[:intervenant_id])
      @cours = Cour.where(etat:Cour.etats[:réalisé]).order(:debut)
      @cours = @cours.where("intervenant_id = ? OR intervenant_binome_id = ?", @intervenant.id, @intervenant.id)
    else 
      flash[:alert] = "Oups... Il me faut au moins un intervenant :)"
      redirect_to action: 'etats_services'
      return
    end

    unless params[:start_date].blank? and params[:end_date].blank?
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @cours = @cours.where("debut between ? and ?", @start_date, @end_date)
    end

    # capture output
    @stream = capture_stdout do
      # Affiche le récap des heures de cours réalisés
      @cours.each do |c|
          puts "#{l(c.debut, format: :short)} | #{c.duree.to_f}h | #{c.formation.nom}"
      end

      puts "\n Total: #{@cours.count} cours, soit #{@cours.sum(:duree)} heure.s réalisée.s"

      # envoyer le récap par mail ?
      if params[:mailer] == "true"
        IntervenantMailer.etat_services(@intervenant.id, @cours.pluck(:id), @start_date, @end_date).deliver_later 
        puts "\n\n Ce récapitulatif vient d'être envoyé à cette adresse: #{@intervenant.email}"
      end
    end  
  end

  def audits
    @audits = Audited::Audit.order("id DESC")
    @types = Audited::Audit.select(:auditable_type).uniq.pluck(:auditable_type)
    
    unless params[:chgt_salle].blank?
      params[:type] = 'Cour'
      params[:search] = 'salle_id'
    end

    unless params[:type].blank?
      @audits = @audits.where(auditable_type:params[:type])
    end

    unless params[:search].blank?
      @audits = @audits.where("audited_changes like ?", "%#{params[:search]}%")
    end

    @audits = @audits.paginate(page:params[:page], per_page:10)
  end

  def taux_occupation
  end

  def taux_occupation_do
    unless params[:start_date].blank? and params[:end_date].blank?
      @start_date = params[:start_date]
      @end_date = params[:end_date]
    else
      flash[:alert] = "Il manque les dates..."
      redirect_to tools_taux_occupation_path
      return
    end

    # Calcul du taux d'occupation
    #

    # salles concernées
    salles_dispo = Salle.salles_de_cours.count
    
    # nombre d'heures salles
    heures_dispo_salles = [salles_dispo * 8, salles_dispo * 4] 

    nbr_jours = total_jour = total_soir = 0
        
    # capture output
    @stream = capture_stdout do
      puts "Date;Taux journée(%);Taux soirée(%)"
      # pour chaque jour entre la date de début et la date de fin
      (@start_date.to_date..@end_date.to_date).each do |d|
        # on ne compte pas le samedi et le dimanche ainsi que les jours de fermetures
        if (d.to_date.wday > 0 && d.to_date.wday <6) && !Fermeture.find_by(date:d.to_date)
          # cumul les heures de cours du jour et du soir
          nombre_heures_cours = [Cour.cumul_heures(d).first, Cour.cumul_heures(d).last]

          # taux d'occupation  
          taux_occupation = [(nombre_heures_cours.first * 100 / heures_dispo_salles.first), (nombre_heures_cours.last * 100 / heures_dispo_salles.last)]
          
          # cumul pour faire la moyenne
          total_jour += taux_occupation.first
          total_soir += taux_occupation.last
          nbr_jours += 1

          puts "#{l(d.to_date)}; #{taux_occupation.first.to_i}%; #{taux_occupation.last.to_i}%"
        end
      end   
      puts "Nombre de jours: #{nbr_jours}"  
      puts  
      puts "Moyenne journée: #{(total_jour / nbr_jours).to_i}%"
      puts "Moyenne soirée: #{(total_soir / nbr_jours).to_i}%"
  end 
  end

end
