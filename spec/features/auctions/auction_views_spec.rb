require 'spec_helper'

describe "#create" do
  subject { page }

  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
  set(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.last.id, :user_id => user.id }

  context "pending approval tag" do
    it "shows when pending_approval" do
      auction.update_attributes(:submitted => true)
      visit auctions_path
      page.should have_css(".auction-not-yet-approved")
    end

    it "does not show when approved" do
      auction.update_attributes(:submitted => true, :approved => true)
      visit auctions_path
      page.should_not have_css(".auction-not-yet-approved")
    end
  end

  it "auction is not browsable if start date is pending" do
    auction.update_attributes(:start => Time.now + 1.week)
    visit auctions_path
    page.should_not have_content(auction.title)
  end
end
