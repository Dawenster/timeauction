require 'spec_helper'

describe "user profile page", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => user }
  set(:reward) { auction.rewards.first }
  # set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

  before do
    login(user)
  end

  context "new user" do
    context "prompts" do
      before do
        visit user_path(user)
      end

      it "on volunteer tab" do
        page.should have_content("Let's start building your volunteer profile", visible: true)
        page.should have_content("Add Karma", visible: true)
      end

      it "on donations tab" do
        all(".section-tab")[1].click
        page.should have_content("No donations yet...", visible: true)
        page.should have_content("Add Karma", visible: true)
      end

      it "on bids tab" do
        all(".section-tab")[2].click
        page.should have_content("No bids yet...", visible: true)
        page.should have_content("Browse auctions", visible: true)
      end

      it "on activities tab" do
        all(".section-tab")[3].click
        page.should have_content("No activities yet...", visible: true)
        page.should have_content("Add Karma", visible: true)
      end
    end
  end

  context "active user" do
    it "can see volunteer hours" do
      create_existing_hours_entry(user, nonprofit)
      visit user_path(user)
      page.should have_content("Feed the kitties", visible: true)
    end

    it "can see donations" do
      create_positive_donations(1200, user, nonprofit)
      visit user_path(user)
      all(".section-tab")[1].click

      page.should have_content("Red Cross", visible: true)
      within ".hours-ribbon" do
        page.should have_content("12", visible: true)
      end
    end

    it "can see auctions bid on" do
      create_positive_donations(1200, user, nonprofit)
      bid = Bid.create(:reward_id => reward.id, :user_id => user.id)
      create_negative_donations(-800, user, bid)
      visit user_path(user)
      all(".section-tab")[2].click

      page.should have_content(auction.title, visible: true)
      within ".bid-amount-above-auction-grid" do
        page.should have_content("8 Karma Points bid", visible: true)
      end
    end

    it "can see all activites" do
      create_existing_hours_entry(user, nonprofit)
      create_positive_donations(1200, user, nonprofit)
      bid = Bid.create(:reward_id => reward.id, :user_id => user.id)
      create_negative_donations(-800, user, bid)
      visit user_path(user)
      all(".section-tab")[3].click

      within ".activity-date-circle" do
        page.should have_content(bid.created_at.strftime("%b %d, %Y"), visible: true)
      end
      page.should have_content("Logged 12 volunteer hours for Feed the kitties", visible: true)
      page.should have_content("Donated $12.00 to #{nonprofit.name}, $1.20 of which was a tip to Time Auction", visible: true)
      page.should have_content(auction.name, visible: true)
    end

    context "edit about" do
      before do
        visit user_path(user)
        find(".edit-about-me").click
      end

      it "toggles textarea" do
        page.should have_css(".about-me-input", visible: true)
      end

      it "saves data" do
        about_text = "I'm so good at this and that."
        find(".about-me-input").set(about_text)
        within ".about-me-input-holder" do
          click_on "Save"
        end
        page.should have_content(about_text, visible: true)
        user.reload
        expect(user.about).to eq(about_text)
      end
    end

    context "edit roles" do
      before do
        HoursEntry.create(:amount => 10, :points => 100, :user_id => user.id, :organization => "Red Cross")
        visit user_path(user)
        find(".edit-role-title-text").click
      end

      it "toggles edit for position title and description" do
        page.should have_css(".edit-role-input", visible: true)
        page.should have_css(".role-description-input", visible: true)
      end

      it "saves role title" do
        role_title = "The supreme leader"
        find(".edit-role-input").set(role_title)
        within ".role-description" do
          click_on "Save"
        end
        page.should have_content(role_title, visible: true)
        expect(Role.last.title).to eq(role_title)
      end

      it "saves role description" do
        role_description = "I do a great job no matter what"
        find(".role-description-input").set(role_description)
        within ".role-description" do
          click_on "Save"
        end
        page.should have_content(role_description, visible: true)
        expect(Role.last.description).to eq(role_description)
      end
    end
  end
end
