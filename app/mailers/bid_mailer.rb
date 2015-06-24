class BidMailer < ActionMailer::Base
  # helper :application # gives access to all helpers defined within `application_helper`.
  include ApplicationHelper
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Time Auction Team" <team@timeauction.org>'

  def successful_bid(bid, user, hk)
    @name = user.first_name
    @name ||= user.email
    @user = user
    @bid = bid
    @reward = bid.reward
    @auction = @reward.auction
    @org = @auction.program ? @auction.program.organization : nil
    @hk_bid = hk
    @admin_email = general_contact_email_from_mailer(@hk_bid)
    @show_stats = @hk_bid ? false : !@reward.hit_target?
    mail(from: format_email_with_name(@admin_email), to: user.email, subject: "Thank you for bidding on '#{@auction.title}'")
  end

  def successful_premium_bid(bid, user)
    @name = user.first_name
    @name ||= user.email
    @bid = bid
    @reward = bid.reward
    @auction = @reward.auction
    @admin_email = general_contact_email_from_mailer(false)
    mail(from: format_email_with_name(@admin_email), to: user.email, subject: "Thank you for bidding on '#{@auction.title}'")
  end

  def waitlist_bid(reward, user)
    @name = user.display_name
    @name ||= user.email
    @reward = reward
    @auction = @reward.auction
    @admin_email = general_contact_email_from_mailer(false)
    mail(from: format_email_with_name(@admin_email), to: user.email, subject: "You are on the waitlist for '#{@auction.title}'")
  end

  def notify_admin(reward, user, type, hk)
    @name = user.display_name
    @name ||= user.email
    @user_id = user.id
    @hours_bid = user.bids.last.hours
    @reward = reward
    @auction = @reward.auction
    @type = type
    @admin_email = general_contact_email_from_mailer(hk)
    mail(from: format_email_with_name(@admin_email), to: format_email_with_name(@admin_email), subject: "#{@type} bid: #{@name} bid on the reward '#{@reward.title}'")
  end

  def admin_confirmation_email(bid)
    @bid = bid
    @user = @bid.user
    @first_name = @user.first_name
    @auction = @bid.reward.auction
    @donor_name = @auction.name
    @donor_position = @auction.position
    @admin_email = general_contact_email_from_mailer(true)
    mail(from: format_email_with_name(@admin_email), to: @user.email, subject: "Successful Bid: Meeting with #{@donor_name}, #{@donor_position}")
  end

  def admin_waitlist_email(bid)
    @bid = bid
    @user = @bid.user
    @first_name = @user.first_name
    @auction = @bid.reward.auction
    @donor_name = @auction.name
    @donor_position = @auction.position
    @admin_email = general_contact_email_from_mailer(true)
    mail(from: format_email_with_name(@admin_email), to: @user.email, subject: "You've been wait-listed for the meeting with #{@donor_name}, #{@donor_position}")
  end
end