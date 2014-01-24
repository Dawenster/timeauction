require 'spec_helper'

describe "manage auctions" do
  subject { page }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  before do
    facebook_login
    visit new_auction_path
    fill_in_initial_auction_fields
  end

  context "#new and #create" do
    context "submit" do
      it "successfully" do
        attach_file :auction_banner, banner_root
        attach_file :auction_image, image_root
        find(".add-a-reward-icon").click
        all(".auction_rewards_title").each_with_index do |title, i|
          title.find("input").set("Awesome reward #{i + 1}")
        end
        all(".auction_rewards_description").each_with_index do |description, i|
          description.find("textarea").set("Awesome reward description #{i + 1}")
        end
        all(".auction_rewards_amount").each_with_index do |reward_amount, i|
          reward_amount.find("input").set(20 * (i + 1))
        end
        fill_in :auction_target, :with => 50
        expect do
          click_on "Submit for approval*"
        end.to change(Auction, :count).by(1)
      end

      it "shows error if not everything filled in" do
        expect do
          click_on "Submit for approval*"
        end.to change(Auction, :count).by(0)
        page.should have_css(".alert")
      end
    end

    context "save" do
      it "saves auction without everything filled in" do
        expect do
          click_on "Save for later"
        end.to change(Auction, :count).by(1)
      end
    end
  end

  context "#edit and #update" do
    set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => user }
    set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
    set(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.last.id, :user_id => user.id }

    it "can be edited if not submitted" do
      visit edit_auction_path(auction)
      page.should have_content("Edit auction")
    end

    it "cannot be edited once submitted" do
      auction.update_attributes(:submitted => true, :target => 10)
      visit edit_auction_path(auction)
      page.should_not have_content("Edit auction")
      page.should have_css(".alert")
    end
  end
end
