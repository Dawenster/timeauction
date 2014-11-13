require 'spec_helper'

describe Organization do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:people_descriptor) }
  it { should validate_uniqueness_of(:url) }

  context "methods" do
    set(:organization_1) { FactoryGirl.create :organization_with_programs_and_email_domains }
    set(:organization_2) { FactoryGirl.create :organization_with_programs_and_email_domains }
    set(:organization_auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => organization_1.programs.first.id, :approved => true, :submitted => true }
    set(:different_organization_auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => organization_2.programs.first.id, :approved => true, :submitted => true }
    set(:user) {
      user_email = "johndoe@" + organization_1.email_domains.first.domain
      FactoryGirl.create :user, :email => user_email
    }

    before do
      organization_auction.update_attributes(:start_time => Time.now)
      different_organization_auction.update_attributes(:start_time => Time.now)
    end

    context "#current_auctions" do
      it "returns correct organization auction" do
        organization_1.current_auctions.should eq([organization_auction])
      end
    end

    context "#pending_auctions" do
      before do
        organization_auction.update_attributes(:start_time => Time.now + 1.day)
        different_organization_auction.update_attributes(:start_time => Time.now + 1.day)
      end

      it "returns correct organization auction" do
        organization_1.pending_auctions.should eq([organization_auction])
      end
    end

    context "#past_auctions" do
      before do
        organization_auction.update_attributes(:start_time => Time.now - 2.days, :end_time => Time.now - 1.day)
        different_organization_auction.update_attributes(:start_time => Time.now - 2.days, :end_time => Time.now - 1.day)
      end

      it "returns correct organization auction" do
        organization_1.past_auctions.should eq([organization_auction])
      end
    end
  end
end
