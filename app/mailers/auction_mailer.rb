class AuctionMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def new_auction_created(auction, user)
    @user_id = user.id
    @username = user.username
    @auction_url = auction_url(auction)
    mail(to: "team@timeauction.org", subject: "A new auction has been created")
  end
end