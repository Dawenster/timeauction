require 'spec_helper'

describe "manage companies" do
  subject { page }

  set(:company) { FactoryGirl.create :company_with_programs_and_email_domains }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => company.programs.first.id, :approved => true, :submitted => true }
  set(:user) { FactoryGirl.create :user }

  before do
    login(user)
  end

  context "companies#show" do
    before do
      visit auction_path(auction)
    end

    it "shows company logo" do
      page.should have_content("Only #{company.name} employees")
    end
  end

  context "bids#bid" do
    it "allows company users to view page" do
      user.update_attributes(:email => make_email(company))

      reward = auction.rewards.first
      visit bid_path(auction, reward)
      page.should have_content("Bid to: #{reward.title}")
    end

    it "does not allow non-company users to view page" do
      visit bid_path(auction, auction.rewards.first)
      page.should have_content("Sorry!")
    end
  end
end
