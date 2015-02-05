class ReachOutMailer < Devise::Mailer
  # helper :application # gives access to all helpers defined within `application_helper`.
  include ApplicationHelper
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"David Wen" <david@timeauction.org>'

  def send_to_non_bidder(non_bidder)
    @first_name = non_bidder[:first_name] ? non_bidder[:first_name].downcase.titleize.strip : "there"
    mail(from: '"David Wen" <david@timeauction.org>', to: non_bidder[:email], subject: "Thank you, from Time Auction")
  end

  def send_to_subscriber(subscriber)
    @first_name = subscriber[:first_name] ? subscriber[:first_name].downcase.titleize.strip : "there"
    mail(from: '"David Wen" <david@timeauction.org>', to: subscriber[:email], subject: "Thank you, from Time Auction")
  end

  def send_to_na_bschool(na_bschool)
    @first_name = na_bschool[:first_name]
    @school_in_content = na_bschool[:school_in_content]
    mail(from: '"David Wen" <david@timeauction.org>', to: na_bschool[:email], subject: "Engaging alumni at #{na_bschool[:school_in_title]}")
  end

  def send_to_ubc_not_bid_yet(ubc_user)
    @first_name = ubc_user[:first_name]
    mail(from: '"David Wen" <david@timeauction.org>', to: ubc_user[:email], subject: "Chat about Sauder Time Auction")
  end

  def first_reachout_ca_post_secondary(school)
    @first_name = school[:first_name]
    @short_name = school[:short_name]
    @long_name = school[:long_name]
    mail(from: '"David Wen" <david@timeauction.org>', to: school[:email], subject: "Engaging #{@short_name} Students")
  end

  def first_reachout_us_independent(school)
    @first_name = school[:first_name]
    @short_name = school[:short_name]
    @long_name = school[:long_name]
    mail(from: '"David Wen" <david@timeauction.org>', to: school[:email], subject: "Engaging #{@short_name} Students")
  end

  def first_reachout_ca_independent(school)
    @first_name = school[:first_name]
    @short_name = school[:short_name]
    @long_name = school[:long_name]
    mail(from: '"David Wen" <david@timeauction.org>', to: school[:email], subject: "Engaging #{@short_name} Students")
  end
end