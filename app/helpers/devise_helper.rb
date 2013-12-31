module DeviseHelper
  def devise_error_messages!
    messages = resource.errors.full_messages.join(". ").html_safe
  end
end