# ENCODING: UTF-8

#app/controllers/api_controller.rb
module Api
    module V2
		class Api::V2::CoursController < ActionController::Base
		    skip_before_action :verify_authenticity_token
		    respond_to :json

			def index
				@cours = Cour.where(etat: Cour.etats.values_at(:planifié, :confirmé)).order(:debut)
				
				if params[:d]
					@cours = @cours.where("DATE(debut)=?", params[:d])
				else
					@cours = @cours.where("debut >= ?", Date.today)
				end
			end	
							
		    def show
		    	cours = Cour.find(params[:id])
		    	render json: cours, 
		    				methods:[:duree, :start_time_short_fr, :nom_ou_ue, :formation_json, :photo_json, :salle_json], 
		    				except:[:created_at, :updated_at]
		    end
		end
	end
end