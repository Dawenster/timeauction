require 'spec_helper'

describe Bid do
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
  set(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
  set(:bid_3) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
  set(:entry_1) { FactoryGirl.create :hours_entry, :bid_id => bid_2.id, :user_id => user.id, :amount => -15 }
  set(:entry_1_earned) { FactoryGirl.create :hours_entry, :bid_id => bid_2.id, :user_id => user.id, :amount => 15 }
  set(:entry_2) { FactoryGirl.create :hours_entry, :bid_id => bid_2.id, :user_id => user.id, :amount => -5 }
  set(:entry_2_earned) { FactoryGirl.create :hours_entry, :bid_id => bid_2.id, :user_id => user.id, :amount => 5 }
  set(:entry_3) { FactoryGirl.create :hours_entry, :bid_id => bid_1.id, :user_id => user.id, :amount => -5, :verified => true }
  set(:entry_3_earned) { FactoryGirl.create :hours_entry, :bid_id => bid_1.id, :user_id => user.id, :amount => 5, :verified => true }

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

  context "#hours" do
    it "counts hours bid based on hours entries" do
      expect(bid_2.hours).to eq(20)
    end

    it "old method of counting pre-set reward hours" do
      expect(bid_3.hours).to eq(12)
    end
  end

  it "#earned_entries" do
    expect(bid_2.earned_entries.first).to eq(entry_1_earned)
  end

  it "#used_entries" do
    expect(bid_2.used_entries.first).to eq(entry_1)
  end

  it "#chance_of_winning" do
    expect(bid_2.chance_of_winning).to eq(80)
  end

  context "#verified?" do
    it "is true" do
      expect(bid_1.verified?).to eq(true)
    end

    it "is false" do
      expect(bid_2.verified?).to eq(false)
    end
  end
end
