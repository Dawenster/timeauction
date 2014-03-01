require 'spec_helper'

describe Reward do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:amount) }

  context "methods" do
    set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 1 }
    set(:user_1) { FactoryGirl.create :user, :email => "johndoe@email.com" }
    set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user_1.id }

    it "#num_bidders" do
      expect(auction.rewards.first.num_bidders).to eq(1)
    end

    context "#maxed_out?" do
      it "is true if num bidders match max" do
        reward = auction.rewards.first
        reward.update_attributes(:max => 1)
        expect(reward.maxed_out?).to eq(true)
      end

      it "is false if num bidders less than max" do
        reward = auction.rewards.first
        reward.update_attributes(:max => 2)
        expect(reward.maxed_out?).to eq(false)
      end

      it "is false if max is nil" do
        expect(auction.rewards.first.maxed_out?).to eq(false)
      end
    end

    context "waitlist bid" do
      it "#num_on_waitlist" do
        reward = auction.rewards.first
        reward.update_attributes(:max => 0)

        expect(reward.num_on_waitlist).to eq(1)
      end
    end
  end
end
