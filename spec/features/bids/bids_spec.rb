require 'spec_helper'

describe "bids" do
  subject { page }

  let!(:creator) { FactoryGirl.create :user }
  let!(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => creator }

  before do
    auction.update_attributes(:target => 10)
    visit auction_path(auction)
  end

  context "not logged in" do
    it "opens signup modal", :js => true do
      all(".bid-button").first.click
      page.should have_selector('#signup-modal', visible: true)
    end
  end

  context "logged in" do
    let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

    before do
      facebook_login
    end

    it "opens signup modal", :js => true do
      all(".bid-button").first.click
      page.should have_selector('#bid-modal', visible: true)
    end
  end
end
