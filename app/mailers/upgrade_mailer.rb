class UpgradeMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def notify_user_of_upgrade(user, period)
    @user = user
    if period == "monthly"
      @amount = "$10.00 per month"
    else
      @amount = "$84.00 per year"
    end
    mail(to: @user.email, subject: "You have upgraded to a Time Auction Supporter")
  end

  def notify_admin(user, message)
    @name = user.display_name
    @name ||= user.username
    @user_id = user.id
    mail(to: "team@timeauction.org", subject: "#{message} - User: #{@name}")
  end
end