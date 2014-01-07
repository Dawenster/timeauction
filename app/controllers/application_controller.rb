class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if referer_match?
      super
    else
      stored_location_for(resource) || request.env['omniauth.origin'] || request.referer || root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end
  end

  def referer_match?
    return false unless resource
    sign_in_url = new_session_url(resource)
    sign_up_url = new_registration_url(resource)
    if Rails.env.production?
      failed_sign_in_url = "http://" + request.host + "/users"
    else
      failed_sign_in_url = "http://" + request.host + ":" + request.port.to_s + "/users"
    end

    return request.referer == sign_in_url || request.referer == sign_up_url || request.referer == failed_sign_in_url
  end
end
