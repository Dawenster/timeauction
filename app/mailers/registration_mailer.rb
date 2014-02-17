class RegistrationMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def confirmation_instructions(resource, token, opts={})
    opts[:subject] = "Confirm your Time Auction account"
    @username = resource.username
    super
  end

  def reset_password_instructions(resource, token, opts={})
    opts[:subject] = "Confirm your Time Auction account"
    @username = resource.username
    super
  end

  def unlock_instructions(resource, token, opts={})
    opts[:subject] = "Confirm your Time Auction account"
    @username = resource.username
    super
  end
end