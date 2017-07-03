#app/controllers/api_controller.rb
module Api
    module V1
		class Api::V1::CoursController < ActionController::Base
		    skip_before_action :verify_authenticity_token

			def index
		        cours = Cour.all
		        render json: cours.where.not(etat:0).where("debut >= ?", Date.today).order(:debut),
		        		 	methods:[:start_time_short_fr, :nom_ou_ue, :formation_json, :photo_json, :salle_json], 
		        		 	except:[:nom, :debut, :fin, :ue, :created_at, :updated_at]
		    end	

		    def show
		    	cours = Cour.find(params[:id])
		    	render json: cours, methods:[:duree, :start_time_short_fr ,:nom_ou_ue, :formation_json, :photo_json, :salle_json], 
		    				except:[:created_at, :updated_at]
		    end

		end
	end
end