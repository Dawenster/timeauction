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

  def waitlist_bid(reward, user)
    @name = user.display_name
    @name ||= user.username
    @reward = reward
    @auction = @reward.auction
    mail(to: user.email, subject: "You are on the waitlist for '#{@auction.title}'")
  end

  def notify_admin(reward, user, type)
    @name = user.display_name
    @name ||= user.username
    @user_id = user.id
    @reward = reward
    @auction = @reward.auction
    @type = type
    mail(to: "team@timeauction.org", subject: "#{@type} bid: #{@name} bid on the reward '#{@reward.title}'")
  end
end