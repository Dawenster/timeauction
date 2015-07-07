require 'spec_helper'

describe "user profile page", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => user }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }

  before do
    login(user)
  end

  context "new user" do
    context "prompts" do
      it "on volunteer tab" do
        visit user_path(user)
        page.should have_content("Let's start building your volunteer profile", visible: true)
        page.should have_content("Add Karma", visible: true)
      end

      it "on donations tab" do
        visit user_path(user)
        all(".section-tab")[1].click
        page.should have_content("No donations yet...", visible: true)
        page.should have_content("Add Karma", visible: true)
      end
    end
  end

  context "active user" do
    it "can see auctions bid on" do
      HoursEntry.create(:amount => 10, :user_id => user.id, :organization => "Red Cross")
      visit user_path(user)
      page.should have_content(auction.title, visible: true)
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
        HoursEntry.create(:amount => 10, :user_id => user.id, :organization => "Red Cross")
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
