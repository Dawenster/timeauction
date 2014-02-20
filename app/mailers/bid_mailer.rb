class BidMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def successful_bid(reward, user)
    @name = user.display_name
    @name ||= user.username
    @reward = reward
    @auction = @reward.auction
    mail(to: user.email, subject: "Thank you for bidding on '#{@auction.title}'")
  end
end