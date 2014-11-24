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
end