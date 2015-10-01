class UserMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def notify_admin_of_account_cancellation(user)
    @name = user.display_name
    @email = user.email
    @user_id = user.id
    mail(to: "team@timeauction.org", subject: "Cancelled user account: #{@name}")
  end

  def welcome_hk(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Welcome to Time Auction Hong Kong!")
  end
end