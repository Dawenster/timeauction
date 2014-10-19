require 'spec_helper'

describe "user activity log" do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => user }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }

  before do
    login(user)
  end

  context "bid on" do
    it "can see auctions bid on", :js => true do
      visit activity_path(user.username)
      page.should have_content(auction.title, visible: true)
    end

    it "cannot see auctions bid on in other tabs", :js => true do
      auction.update_attributes(:user_id => 200)
      visit activity_path(user.username)
      click_on "Saved"
      page.should_not have_content(auction.title, visible: true)
      click_on "Submitted"
      page.should_not have_content(auction.title, visible: true)
      click_on "Approved"
      page.should_not have_content(auction.title, visible: true)
    end
  end

  context "saved" do
    it "can see saved auctions", :js => true do
      visit activity_path(user.username)
      click_on "Saved"
      page.should have_content(auction.title, visible: true)
    end

    it "cannot see saved auctions in other tabs", :js => true do
      bid_1.update_attributes(:user_id => 200)
      visit activity_path(user.username)
      page.should_not have_content(auction.title, visible: true)
      click_on "Submitted"
      page.should_not have_content(auction.title, visible: true)
      click_on "Approved"
      page.should_not have_content(auction.title, visible: true)
    end
  end

  context "submitted" do
    it "can see submitted auctions", :js => true do
      auction.update_attributes(:submitted => true)
      visit activity_path(user.username)
      click_on "Submitted"
      page.should have_content(auction.title, visible: true)
    end

    it "cannot see submitted auctions in other tabs", :js => true do
      bid_1.update_attributes(:user_id => 200)
      auction.update_attributes(:submitted => true)
      visit activity_path(user.username)
      page.should_not have_content(auction.title, visible: true)
      click_on "Saved"
      page.should_not have_content(auction.title, visible: true)
      click_on "Approved"
      page.should_not have_content(auction.title, visible: true)
    end
  end

  context "approved" do
    it "can see approved auctions", :js => true do
      auction.update_attributes(:submitted => true, :approved => true)
      visit activity_path(user.username)
      click_on "Approved"
      page.should have_content(auction.title, visible: true)
    end

    it "cannot see approved auctions in other tabs", :js => true do
      bid_1.update_attributes(:user_id => 200)
      auction.update_attributes(:submitted => true, :approved => true)
      visit activity_path(user.username)
      page.should_not have_content(auction.title, visible: true)
      click_on "Saved"
      page.should_not have_content(auction.title, visible: true)
      click_on "Submitted"
      page.should_not have_content(auction.title, visible: true)
    end
  end

  # context "pending approval tag" do
    # it "shows when pending_approval" do
    #   auction.update_attributes(:submitted => true)
    #   visit activity_path(user.username)
    #   click_on "Saved"
    #   page.should have_css(".auction-not-yet-approved")
    # end

    # it "does not show when approved" do
    #   auction.update_attributes(:submitted => true, :approved => true)
    #   visit activity_path(user.username)
    #   click_on "Approved"
    #   page.should_not have_css(".auction-not-yet-approved")
    # end
  # end
end
