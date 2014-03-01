require 'spec_helper'

describe "Auction views" do
  subject { page }

  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :submitted => true, :approved => true }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  
  context "auctions#index" do
    it "current auctions show up in the right section" do
      visit auctions_path
      within ".current-auctions" do
        page.should have_content(auction.title)
      end
    end

    it "pending auctions show up in the right section" do
      auction.update_attributes(:start => Time.now + 1.week, :end => Time.now + 2.weeks)
      visit auctions_path
      within ".pending-auctions" do
        page.should have_content(auction.title)
      end
    end
  end

  context "auctions#show" do
    context "pending auction" do
      before do
        auction.update_attributes(:start => Time.now + 1.week, :end => Time.now + 2.weeks, :target => 1)
      end

      # it "shows auction is pending if it is yet to start" do
      #   visit auction_path(auction)
      #   page.should have_css(".auction-pending-start")
      # end

      context "not started modal" do
        before do
          facebook_login
          visit auction_path(auction)
          sleep 1
          all(".bid-button").first.click
        end

        it "shows", :js => true do
          page.should have_selector('#not-started-modal', visible: true)
        end

        it "can subscribe email", :js => true do
          expect do
            sleep 1
            click_on "Subscribe"
            sleep 1
          end.to change(Subscriber, :count).by(1)
          page.should have_content("has been added successfully")
        end
      end
    end
  end
end

