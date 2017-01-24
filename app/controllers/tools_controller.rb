# ENCODING: UTF-8

class ToolsController < ApplicationController
  require 'csv'
  require 'capture_stdout'

  def index
  end

  def import_do
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

		CSV.foreach(file_with_path, headers:true, col_sep:';', quote_char:'"', encoding:'UTF-8') do |row|
			index += 1
			puts "Ligne ##{index}"

			# Date;Heure début;Heure fin;Durée;UE;Intervenant;Intitulé
			int= row['Intervenant'] ? Intervenant.where("nom like ?", row['Intervenant'].split(' ').first).first : nil

			cours = Cour.new(debut:row['Date'] + " " + row['Heure début'], 
							fin:row['Date'] + " " + row['Heure fin'], 
							formation_id: params[:formation_id], 
							ue:row['UE'], intervenant:int, nom:row['Intitulé'] )
			
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
		puts "=" * 80
		puts "Lignes importées: #{@importes} | Lignes ignorées: #{@errors}"
		puts "=" * 80
      end

      # save output            
      @now = DateTime.now.to_s
      #File.open("public/Documents/Import_logements-#{@now}.txt", "w") { |file| file.write @out }
    else
      flash[:alert] = "Manque le fichier source pour lancer l'importation !"
      redirect_to action: 'import'
    end  

  end

end
