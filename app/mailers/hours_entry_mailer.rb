class HoursEntryMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def submitted(hours_entry)
    @hours_entry = hours_entry
    @user = @hours_entry.user
    mail(to: "team@timeauction.org", subject: "A user submitted hours for approval")
  end
end