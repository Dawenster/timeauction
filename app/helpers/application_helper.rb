module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def formatted_date(date)
    return nil if date.nil?
    date.strftime("%b %d, %Y")
  end

  def generate_meta_tags(title, description, image)
    meta :title => title, :description => description
    meta [:property => "og:image", :content => image] unless image.blank?
    meta [:property => "og:title", :content => title]
    meta [:property => "og:url", :content => request.original_url]
    meta [:property => "og:description", :content => description]
    meta [:property => "og:type", :content => "website"]
  end

  def general_contact_email
    if hk_domain?
      "timeauctionhk@gmail.com"
    else
      "team@timeauction.org"
    end
  end

  def general_contact_email_from_mailer(hk)
    if hk
      "timeauctionhk@gmail.com"
    else
      "team@timeauction.org"
    end
  end

  def format_email_with_name(email)
    '"Time Auction Team" <' + email + '>'
  end

  def active_if_on_page(page)
    return "active" if params[:action] == page
  end

  def facebook_app_id
    if Rails.env.production?
      return ENV['FACEBOOK_APP_ID']
    else
      return ENV['FACEBOOK_DEV_APP_ID']
    end
  end

  def facebook_share_url
    if hk_domain?
      return "https://www.facebook.com/timeauctionhk"
    else
      return "https://www.facebook.com/timeauction.org"
    end
  end

  def user_has_organizations?
    current_user ? current_user.organizations.any? : false
  end

  def organizations_to_links(user)
    orgs = user.organizations.map do |org|
      link_to org.name, organization_name_path(org.url)
    end
    return orgs.to_sentence
  end
end
