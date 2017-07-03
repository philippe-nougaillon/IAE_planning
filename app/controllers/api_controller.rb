#app/controllers/api_controller.rb

class ApiController < ApplicationController 
    skip_before_action :verify_authenticity_token

	def index
        cours = Cours.all
        render json: {status: 'SUCCESS', message: 'Loaded all posts', data: cours}, status: :ok
    end 
end