class UpgradeMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def notify_user_of_upgrade(user)
    @user = user
    mail(to: @user.email, subject: "You have upgraded to be a Time Auction Supporter")
  end

  def notify_admin(user, message)
    @name = user.display_name
    @name ||= user.username
    @user_id = user.id
    mail(to: "team@timeauction.org", subject: "#{message} - User: #{@name}")
  end
end