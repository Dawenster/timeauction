require 'spec_helper'

describe "user profile page" do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => user }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }

  before do
    login(user)
  end

  context "new user" do
    it "sees prompt to log hours", :js => true do
      visit user_path(user)
      page.should have_content("Let's start building your profile", visible: true)
    end
  end

  context "active user" do
    it "can see auctions bid on", :js => true do
      HoursEntry.create(:amount => 10, :user_id => user.id, :organization => "Red Cross")
      visit user_path(user)
      page.should have_content(auction.title, visible: true)
    end

    context "edit about" do
      before do
        visit user_path(user)
        find(".edit-about-me").click
      end

      it "toggles textarea", :js => true do
        page.should have_css(".about-me-input", visible: true)
      end

      it "saves data", :js => true do
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
  end
end
