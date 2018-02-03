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

      # Date;Heure début;Heure fin;Durée;UE;Intervenant;Intitulé

      # capture output
      @stream = capture_stdout do
        @importes = @errors = 0 

        index = 1

        CSV.foreach(file_with_path, headers:true, col_sep:';', quote_char:'"', encoding:'iso-8859-1:UTF-8') do |row|
          index += 1

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
          cours = Cour.new(debut:debut, fin:fin, duree:((cours.fin - cours.debut)/3600), formation_id:params[:formation_id], intervenant:intervenant, ue:row['UE'].try(:strip), nom:row['Intitulé'])
          if cours.valid? 
            cours.save if params[:save] == 'true'
            @importes += 1
          else
            @errors += 1
            puts "Ligne ##{index} | COURS INVALIDE !! Erreur => #{cours.errors.messages} | Source: #{row} \n\r"
          end
          puts
        end
        puts "----------- Les modifications n'ont pas été enregistrées ! ---------------" unless params[:save] == 'true'
        puts
        puts "=" * 40
        puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
        puts "=" * 40
      end

      # save output            
      # @now = DateTime.now.to_s
      # File.open("public/Documents/Import_logements-#{@now}.txt", "w") { |file| file.write @out }
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
            UserMailer.welcome_email(user.id, generated_password).deliver_now if params[:save] == 'true'
            
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
  	# if params[:duree].blank?
    #   flash[:alert] = "Erreur... manque la durée"
    #   redirect_to action: 'creation_cours'
    #   return
    # end 

	  @start_date = Date.civil(params[:cours]["start_date(1i)"].to_i,
                         	 params[:cours]["start_date(2i)"].to_i,
                         	 params[:cours]["start_date(3i)"].to_i)

	  @end_date = Date.civil(params[:cours]["end_date(1i)"].to_i,
                           params[:cours]["end_date(2i)"].to_i,
                           params[:cours]["end_date(3i)"].to_i)

    # Calcul le nombre de jours à traiter dans la période à traiter
  	@ndays = (@end_date - @start_date).to_i
	  duree = params[:duree]
	  salle_id = params[:salle_id]
    nom_cours = params[:nom]
    semaines = params[:semaines]

  	@cours_créés = @erreurs = 0

    @stream = capture_stdout do
      current_date = @start_date
      # Pour chaque jour de la période à traiter
      @ndays.times do
        # test jour
        wday = current_date.wday
        ok_jours = ((params[:lundi] && wday == 1) || (params[:mardi] && wday == 2) || 
                    (params[:mercredi] && wday == 3) || (params[:jeudi] && wday == 4) || 
                    (params[:vendredi] && wday == 5) || (params[:samedi] && wday == 6))
        # test semaine 
        ok_semaines = (params[:semaines] && params[:semaines].include?(current_date.cweek.to_s))
        # création du cours
        new_cours = Cour.new(formation_id:params[:formation_id], intervenant_id:params[:intervenant_id], nom:nom_cours, salle_id:salle_id)

        if params[:am] || params[:pm]
          if params[:am]
            new_cours.duree = 3
            new_cours.debut = Time.zone.parse(current_date.to_s + " 9:00").utc
            new_cours.fin = eval("new_cours.debut + #{new_cours.duree}.hour")
          elsif params[:pm]
            new_cours.duree = 4
            new_cours.debut = Time.zone.parse(current_date.to_s + " 13:00").utc
            new_cours.fin = eval("new_cours.debut + #{new_cours.duree}.hour")
          end
          # création du cours de l'après midi si besoin
          if (params[:am] && params[:pm])
            new_cours_pm = Cour.new(formation_id:params[:formation_id], intervenant_id:params[:intervenant_id], nom:nom_cours, salle_id:salle_id)
            new_cours_pm.duree = 4
            new_cours_pm.debut = Time.zone.parse(current_date.to_s + " 13:00").utc
            new_cours_pm.fin = eval("new_cours_pm.debut + #{new_cours_pm.duree}.hour")
          end  
        else
          # calcul de la date & heure de début et de fin  
          new_cours.duree = duree
          new_cours.debut = Time.zone.parse(current_date.to_s + " #{params[:cours]["start_date(4i)"]}:#{params[:cours]["start_date(5i)"]}").utc
          new_cours.fin = eval("new_cours.debut + #{new_cours.duree}.hour")
        end

        if ok_jours && ok_semaines
          msg = "#{I18n.l(new_cours.debut, format: :long)} => #{I18n.l(new_cours.fin, format: :heures_min)}"
          # création du cours
          if new_cours.valid?
            new_cours.save if params[:save] == 'true'
            puts "[Création OK] #{msg}"
            @cours_créés += 1
          else
            puts "[Erreur!] #{msg}"
            @erreurs += 1
          end
          # création de deux cours (matin+soir)
          if (params[:am] && params[:pm])
            msg = "#{I18n.l(new_cours_pm.debut, format: :long)} => #{I18n.l(new_cours_pm.fin, format: :heures_min)}"
            if new_cours_pm.valid?
              new_cours_pm.save if params[:save] == 'true'
              puts "[Création OK] #{msg}"              
              @cours_créés += 1
            else
              puts "[Erreur!] #{msg}"
              @erreurs += 1
            end  
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
      flash[:error] = "Oups... Il faudrait le nom de l'intervenant"
      redirect_to action: 'etats_services'
      return
    end

    unless params[:start_date].blank? || params[:end_date].blank?
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @cours = @cours.where("debut between ? and ?", @start_date, @end_date)
    else
      flash[:error] = "Oups... Il faut une date de début et une date de fin"
      redirect_to tools_etats_services_path(params)  
      return
    end
    @cumul_hetd = 0
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

  def taux_occupation_jours
  end

  def taux_occupation_jours_do
    unless params[:start_date].blank? and params[:end_date].blank?
      @start_date = params[:start_date]
      @end_date = params[:end_date]
    else
      flash[:error] = "Il manque les dates..."
      redirect_to tools_taux_occupation_jours_path
      return
    end

    # Calcul du taux d'occupation
    #

    # salles concernées
    salles_dispo = Salle.salles_de_cours.count
    salles_dispo_samedi = Salle.salles_de_cours_du_samedi.count
    
    # amplitude 
    @nb_heures_journée = Salle.nb_heures_journée
    @nb_heures_soirée = Salle.nb_heures_soirée

    # nombre d'heures salles semaine
    heures_dispo_salles = [salles_dispo * @nb_heures_journée, salles_dispo_samedi * @nb_heures_soirée] 

    # nombre d'heures salles samedi
    heures_dispo_salles_samedi = [salles_dispo_samedi * @nb_heures_journée, salles_dispo_samedi * @nb_heures_soirée] 

    @nbr_jours = @total_jour = @total_soir = 0

    @@results = []
    # pour chaque jour entre la date de début et la date de fin
    (@start_date.to_date..@end_date.to_date).each do |d|
      # on ne compte pas le dimanche ni les jours de fermetures
      if d.to_date.wday > 0 && !Fermeture.find_by(date:d.to_date)
        # cumul les heures de cours du jour et du soir
        nombre_heures_cours = [Cour.cumul_heures(d).first, Cour.cumul_heures(d).last]

        # calcul du taux d'occupation  
        if d.to_date.wday == 6 # le samedi, on ne comtpe que le batiment D
          taux_occupation = [(nombre_heures_cours.first * 100 / heures_dispo_salles_samedi.first),
                              (nombre_heures_cours.last * 100 / heures_dispo_salles_samedi.last)]
          @total_jour += taux_occupation.first
        else  
          taux_occupation = [(nombre_heures_cours.first * 100 / heures_dispo_salles.first), 
                              (nombre_heures_cours.last * 100 / heures_dispo_salles.last)]
          @total_jour += taux_occupation.first
          @total_soir += taux_occupation.last
        end  
        @nbr_jours += 1

        @@results << [l(d.to_date, format: :long), taux_occupation.first.to_i, taux_occupation.last.to_i]
      end
    end   
  end

  def taux_occupation_salles
  end

  def taux_occupation_salles_do
    unless params[:start_date].blank? and params[:end_date].blank?
      @start_date = params[:start_date]
      @end_date = params[:end_date]
    else
      flash[:error] = "Il manque les dates..."
      redirect_to tools_taux_occupation_salles_path
      return
    end

    # Calcul du taux d'occupation par salles
    #
    
    # amplitude 
    @nb_heures_journée = Salle.nb_heures_journée
    @nb_heures_soirée = Salle.nb_heures_soirée

    # nombre de jours dans la période
    @nbr_jours = 0
    # nombre d'heures de disponibilité des salles 
    @nbr_heures_dispo_salle = 0
    # fait le cumul des jours et des heures de dispo salle
    (@start_date.to_date..@end_date.to_date).each do |d|
      # on ne compte pas le dimanche ni les jours de fermetures
      next if Fermeture.find_by(date:d.to_date)
      case d.to_date.wday 
          when 0    # dimanche
          when 1..5 # jours de la semaine 
            @nbr_jours += 1
            @nbr_heures_dispo_salle += (@nb_heures_journée + @nb_heures_soirée)
          when 6   # samedi
            @nbr_jours += 1
            @nbr_heures_dispo_salle += @nb_heures_journée
      end
    end 

    @results = {}
    Cour.where("debut between DATE(?) AND DATE(?) AND salle_id NOT NULL", @start_date, @end_date).each do | c |
      if Salle.salles_de_cours.include?(c.salle)
        salle = c.salle.nom
        if @results[salle]
          @results[salle] += c.duree.to_f
        else
          @results[salle] = c.duree.to_f
        end
      end
    end
  end

end
