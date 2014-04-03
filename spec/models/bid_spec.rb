require 'spec_helper'

describe Bid do
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
  set(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }

  before do
    auction.rewards.first.update_attributes(:max => 1, :amount => 12)
  end

  context "#successful?" do
    it "is true" do
      expect(bid_1.successful?).to eq(true)
    end

    it "is false" do
      expect(bid_2.successful?).to eq(false)
    end
  end

  context "#waitlist?" do
    it "is false" do
      expect(bid_1.waitlist?).to eq(false)
    end

    it "is true" do
      expect(bid_2.waitlist?).to eq(true)
    end
  end

  it "#hours" do
    expect(bid_1.hours).to eq(12)
  end
end
