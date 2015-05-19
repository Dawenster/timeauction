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

  def general_mail_to(text, style)
    "#{mail_to general_contact_email, text, :encode => 'hex', 'data-tooltip' => '', 'aria-haspopup' => 'true', :class => 'has-tip', :title => 'We won\'t ignore you! We aim to reply all emails within 24 hours.', :style => style, 'data-options' => 'disable_for_touch:true'}"
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
      return "https://www.facebook.com/timeauction"
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

  def general_eligible_period
    org_specific_auction_page = @auction && @auction.program
    if org_specific_auction_page
      return @auction.program.eligible_period
    else
      return "in the last 3 months"
    end
  end

  def total_hours_raised
    "13,000"
  end

  def is_landing_page?
    params[:action] == "landing" && params[:controller] == "pages"
  end

  def profile_picture(user, large)
    if user.uid
      image_tag "https://graph.facebook.com/#{user.uid}/picture?width=350&height=350", :class => "user-avatar#{'-large' if large}"
    elsif user.profile_picture.exists?
      if large
        image_tag user.profile_picture.url(:large), :class => "user-avatar-large"
      else
        image_tag user.profile_picture.url(:small), :class => "user-avatar"
      end
    else
      image_tag "https://s3-us-west-2.amazonaws.com/timeauction/no-profile-image.png", :class => "user-avatar#{'-large' if large}"
    end
  end
end
