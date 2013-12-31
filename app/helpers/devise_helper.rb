module DeviseHelper
  def devise_error_messages!
    messages = resource.errors.full_messages.map { |msg| content_tag(:div, msg) }.join(". ").html_safe
  end
end