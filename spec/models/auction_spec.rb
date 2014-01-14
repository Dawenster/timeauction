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

  context "when registering" do
    let(:auction) { FactoryGirl.create :auction }
    let(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

    it "#hours_raised" do
      auction.rewards.each do |reward|
        reward.users << user
      end
      expect(auction.hours_raised).to eq(30)
    end
  end
end
