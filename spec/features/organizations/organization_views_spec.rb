require 'spec_helper'

describe "manage organizations" do
  subject { page }

  set(:organization) { FactoryGirl.create :organization_with_programs_and_email_domains }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => organization.programs.first.id, :approved => true, :submitted => true }
  set(:user) { FactoryGirl.create :user }

  before do
    login(user)
  end

  context "organizations#show" do
    before do
      visit auction_path(auction)
    end

    it "shows organization logo" do
      page.should have_content("Only #{organization.name}")
    end
  end

  context "bids#bid" do
    it "allows organization users to view page" do
      user.update_attributes(:email => make_email(organization))

      reward = auction.rewards.first
      visit bid_path(auction, reward)
      page.should have_content(reward.title)
    end

    it "does not allow non-organization users to view page" do
      visit bid_path(auction, auction.rewards.first)
      page.should have_content("Sorry!")
    end
  end
end
