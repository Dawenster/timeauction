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
  end
end
