class HoursEntryMailer < Devise::Mailer
  # helper :application # gives access to all helpers defined within `application_helper`.
  include ApplicationHelper
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def submitted(hours_entry, hk)
    @hours_entry = hours_entry
    @user = @hours_entry.user
    @admin_email = general_contact_email_from_mailer(hk)
    mail(from: format_email_with_name(@admin_email), to: @admin_email, subject: "A user submitted hours for approval")
  end

  def verified(hours_entry)
    @hours_entry = hours_entry
    @user = @hours_entry.user
    @org = @user.organizations.first
    mail(to: @user.email, subject: "Time Auction has verified #{@hours_entry.amount_in_words}")
  end

  def verification(hours_entry)
    @hours_entry = hours_entry
    @similar_entries = @hours_entry.similar_unverified_entries
    @user = @hours_entry.user
    mail(from: '"David Wen" <david@timeauction.org>', to: @hours_entry.contact_email, subject: "Volunteer hours by #{@user.display_name.titleize}")
  end

  def verification_hk(hours_entry)
    @hours_entry = hours_entry
    @user = @hours_entry.user
    mail(from: '"Fion Leung" <timeauctionhk@gmail.com>', to: @hours_entry.contact_email, subject: "Volunteer hours by #{@user.display_name.titleize}")
  end
end