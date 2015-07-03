class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :add_user_to_mailchimp, if: :can_add_to_mailchimp?
  before_filter :set_first_time_sign_in_cookie, if: :first_time_sign_in?
  before_filter :set_mailer_host

  helper_method :on_production_server?, :can_submit_hours?, :hk_domain?, :can_show_upgrade, :organization_user?, :max_bid, :donation_conversion, :volunteer_conversion, :total_karma_for, :general_eligible_period

  def after_sign_in_path_for(resource)
    if referer_match?
      super
    else
      stored_location_for(resource) || (request.referer if params[:controller] == "auctions") || user_path(resource) || root_path # request.env['omniauth.origin']
    end
  end

  def on_production_server?
    Rails.env.production? && !(ENV['TA_ENVIRONMENT'] == "staging")
  end

  def authenticate_admin!
    unless current_user.try(:admin?)
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  def hk_domain?
    hk = params[:hk] == "yes" || request.host == "timeauction.hk" || request.original_url.include?("timeauction.hk")
    $hk = hk
    return hk
  end

  def can_show_upgrade
    user_signed_in? && !current_user.organizations.any? && !current_user.premium_and_valid? && !hk_domain?
  end

  def organization_user?
    current_user && current_user.organizations.any?
  end

  def max_bid
    return 100
  end

  def donation_conversion
    return {
      :dollars => 1,
      :points => 1
    }
  end

  def volunteer_conversion
    return {
      :hours => 1,
      :points => 10
    }
  end

  def donation_conversion_in_words
    return "#{donation_conversion[:points]} Karma #{'Point'.pluralize(donation_conversion[:points])}"
  end

  def volunteer_conversion_in_words
    return "#{volunteer_conversion[:points]} Karma #{'Point'.pluralize(volunteer_conversion[:points])}"
  end

  def total_karma_for(user)
    user.net_points_from_hours + user.total_donations.round * donation_conversion[:points] + user.bonus_points
  end

  def general_eligible_period
    org_specific_auction_page = @auction && @auction.program
    if org_specific_auction_page
      return @auction.program.eligible_period
    else
      return "since Jan. 1, 2015"
    end
  end

  protected

  def set_first_time_sign_in_cookie
    cookies[:first_time_sign_in] = true
  end

  def first_time_sign_in?
    current_user && current_user.sign_in_count == 1 && cookies[:first_time_sign_in].nil?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :phone_number, :profile_picture, :password_confirmation)
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

  def can_submit_hours?
    hk_domain? && current_user.bids.any?
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def can_add_to_mailchimp?
    !Rails.env.test? && first_time_sign_in?
  end

  def add_user_to_mailchimp
    current_user.add_to_mailchimp
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
