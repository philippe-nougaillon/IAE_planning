class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_action :authenticate_user!, except: [:index]
  before_action :authenticate_user!
  before_action :detect_device_format

  def detect_device_format
    case request.user_agent
        when /iPhone/i, /Android/i && /mobile/i, /Windows Phone/i
          request.variant = :phone
        else
          request.variant = :desktop
      end
  end

end
