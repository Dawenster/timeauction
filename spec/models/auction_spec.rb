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

    before { FactoryGirl.reload }

    it "#hours_raised" do
      expect(auction.hours_raised).to eq(30)
    end

    it "#raised_percentage" do
      auction.update_attributes(:target => 10)
      expect(auction.raised_percentage).to eq("300%")
    end
  end
end
