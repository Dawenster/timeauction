require 'spec_helper'

describe Auction do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:about) }
  it { should validate_presence_of(:target) }
  it { should validate_presence_of(:start) }
  it { should validate_presence_of(:end) }
  it { should validate_presence_of(:volunteer_end_date) }
  it { should validate_presence_of(:banner) }
  it { should validate_presence_of(:image) }

  context "raised hours" do
    let!(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
    let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
    let!(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
    let!(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.last.id, :user_id => user.id }

    before do
      FactoryGirl.reload
    end

    after do
      FactoryGirl.reload
    end

    it "#hours_raised" do
      expect(auction.hours_raised).to eq(30)
    end

    it "#raised_percentage" do
      auction.update_attributes(:target => 10)
      expect(auction.raised_percentage).to eq("300%")
    end

    it "#rewards_ordered_by_lowest" do
      expect(auction.rewards_ordered_by_lowest.first).to eq(auction.rewards.first)
    end

    it "#lowest_bid" do
      expect(auction.lowest_bid).to eq(10)
    end

    it "#volunteers" do
      expect(auction.volunteers).to eq([user])
    end

    it "#num_volunteers" do
      expect(auction.num_volunteers).to eq(1)
    end

    it "#days_left_to_bid > 48 hours" do
      expect(auction.days_left_to_bid).to eq([6, "days"])
    end

    it "#days_left_to_bid < 48 hours" do
      auction.update_attributes(:end => Time.now + 1.day)
      expect(auction.days_left_to_bid).to eq([23, "hours"])
    end

    it "#average_bid" do
      expect(auction.average_bid).to eq("30")
    end

    it "is #pending_approval" do
      auction.update_attributes(:submitted => true)
      expect(auction.pending_approval).to eq(true)
    end

    it "is not #pending_approval" do
      expect(auction.pending_approval).to eq(false)
      auction.update_attributes(:submitted => true, :approved => true)
      expect(auction.pending_approval).to eq(false)
    end

    it "is #over?" do
      auction.update_attributes(:end => Time.now - 1.day)
      expect(auction.over?).to eq(true)
    end

    it "is not #over?" do
      expect(auction.over?).to eq(false)
    end
  end
end
