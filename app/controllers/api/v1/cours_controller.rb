# ENCODING: UTF-8

#app/controllers/api_controller.rb
module Api
    module V1
		class Api::V1::CoursController < ActionController::Base
		    skip_before_action :verify_authenticity_token

			def index
				# - Heure de début (sous forme de date)
				# - Heure de fin (sous forme de date)
				# - Durée (sous forme d'entier correspondant à des minutes)
				# - Salle (string)
				# - Matière (string)
				# - Promo (string)
				# - Nom de l'enseignant (string)
				# - Formation (string)

		        # cours = Cour.all
		        # render json: cours.where.not(etat:0).where("debut >= ?", Date.today).order(:debut),
		        # 		 	methods:[:start_time_short_fr, :nom_ou_ue, :formation_json, :photo_json, :salle_json], 
				# 		 	except:[:nom, :debut, :fin, :ue, :created_at, :updated_at]
				
				render json: Cour.where(etat: Cour.etats.values_at(:planifié, :confirmé)).where("debut >= ?", Date.today).order(:debut),
							methods:[:duree_json, :salle_json, :matiere_json, :formation_json, :intervenant_json],
							except:[:created_at, :updated_at, :id, :salle_id, :formation_id, :intervenant_id, :intervenant_binome_id, :etat, :duree, :ue, :nom]
			
			end	
							
		    def show
		    	cours = Cour.find(params[:id])
		    	render json: cours, methods:[:duree, :start_time_short_fr ,:nom_ou_ue, :formation_json, :photo_json, :salle_json], 
		    				except:[:created_at, :updated_at]
		    end

		end
	end
end