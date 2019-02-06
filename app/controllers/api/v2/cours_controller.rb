# ENCODING: UTF-8

#app/controllers/api_controller.rb
module Api
    module V2
		class Api::V2::CoursController < ActionController::Base
		    skip_before_action :verify_authenticity_token
		    respond_to :json

			def index
				@cours = Cour.where(etat: Cour.etats.values_at(:planifié, :confirmé))
							 .where("DATE(debut)=?", params[:d])
							 .order(:debut)
			end	
		end
	end
end