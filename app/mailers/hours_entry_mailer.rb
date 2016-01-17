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
    @hours_entries = @hours_entry.similar_unverified_entries
    @hours = @hours_entries.inject(0){|memo, entry| memo += entry.amount}
    @user = @hours_entry.user
    @org = @user.organizations.first
    mail(to: @user.email, subject: "Time Auction has verified #{@hours} #{'hour'.pluralize(@hours)}")
  end

  def verification(hours_entry)
    @hours_entry = hours_entry
    @similar_entries = @hours_entry.similar_unverified_entries
    @user = @hours_entry.user
    mail(from: '"David Wen" <david@timeauction.org>', to: @hours_entry.contact_email, subject: "Volunteer hours by #{@user.display_name.titleize}")
  end

  def verification_hk(hours_entry, current_user_id)
    @hours_entry = hours_entry
    @user = @hours_entry.user
    @admin_user = User.find(current_user_id)
    mail(from: "#{@admin_user.display_name} <timeauctionhk@gmail.com>", to: @hours_entry.contact_email, subject: "Please verify: Volunteer hours by #{@user.display_name.titleize} at #{@hours_entry.nonprofit.name}")
  end
end