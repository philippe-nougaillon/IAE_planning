class ApplicationController < ActionController::Base
  
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: [:index_slide]
  before_action :detect_device_format
  before_filter :set_layout_variables

  private
    def set_layout_variables
      @ctrl = params[:controller]
      @sitename ||= request.subdomains.any? ? request.subdomains(0).first.upcase : "IAE-Planning DEV"
      @sitename.concat(" v1.8") 

      if current_user
        @cours_params = {}
      end  
    end

    def detect_device_format
      case request.user_agent
      when /iPhone/i, /Android/i && /mobile/i, /Windows Phone/i
        request.variant = :phone
      else
        request.variant = :desktop
      end
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
  
end
