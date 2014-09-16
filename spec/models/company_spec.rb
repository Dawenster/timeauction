require 'spec_helper'

describe Company do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }

  set(:company) { FactoryGirl.create :company_with_programs_and_email_domains }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => company.programs.first.id }
  set(:user) {
    user_email = "johndoe@" + company.email_domains.first.domain
    FactoryGirl.create :user, :email => user_email
  }

  context "methods" do
    before do
    end

    context "#current_auctions" do
      it "" do

      end
    end
  end
end
