require 'spec_helper'

describe "#create" do
  subject { page }

  let!(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
  let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  let!(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
  let!(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.last.id, :user_id => user.id }

  it "pending_approval auction shows tag" do
    auction.update_attributes(:submitted => true)
    visit auctions_path
    page.should have_css(".auction-not-yet-approved")
  end

  it "approved auction does not shows tag" do
    auction.update_attributes(:submitted => true, :approved => true)
    visit auctions_path
    page.should_not have_css(".auction-not-yet-approved")
  end
end
