require 'spec_helper'

describe Company do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }

  context "methods" do
    set(:company_1) { FactoryGirl.create :company_with_programs_and_email_domains }
    set(:company_2) { FactoryGirl.create :company_with_programs_and_email_domains }
    set(:company_auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => company_1.programs.first.id, :approved => true, :submitted => true }
    set(:different_company_auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => company_2.programs.first.id, :approved => true, :submitted => true }
    set(:user) {
      user_email = "johndoe@" + company_1.email_domains.first.domain
      FactoryGirl.create :user, :email => user_email
    }

    before do
      company_auction.update_attributes(:start_time => Time.now)
      different_company_auction.update_attributes(:start_time => Time.now)
    end

    context "#current_auctions" do
      it "returns correct company auction" do
        company_1.current_auctions.should eq([company_auction])
      end
    end

    context "#pending_auctions" do
      before do
        company_auction.update_attributes(:start_time => Time.now + 1.day)
        different_company_auction.update_attributes(:start_time => Time.now + 1.day)
      end

      it "returns correct company auction" do
        company_1.pending_auctions.should eq([company_auction])
      end
    end

    context "#past_auctions" do
      before do
        company_auction.update_attributes(:start_time => Time.now - 2.days, :end_time => Time.now - 1.day)
        different_company_auction.update_attributes(:start_time => Time.now - 2.days, :end_time => Time.now - 1.day)
      end

      it "returns correct company auction" do
        company_1.past_auctions.should eq([company_auction])
      end
    end
  end
end
