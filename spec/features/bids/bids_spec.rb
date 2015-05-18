require 'spec_helper'

describe "bids" do
  subject { page }

  set(:creator) { FactoryGirl.create :user }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => creator }
  set(:reward) { auction.rewards.first }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:entry) { FactoryGirl.create :hours_entry, :amount => 100, :user_id => user.id }

  context "not logged in" do
    it "opens signup modal", :js => true do
      visit auction_path(auction)
      find("body")
      all(".bid-button").first.click
      page.should have_selector('#signup-modal', visible: true)
    end
  end

  context "logged in" do
    before do
      login(user)
    end

    context "before auction start date" do
      it "clicking bid button shows modal", :js => true do
        auction.update_attributes(:start_time => Time.now + 1.day, :approved => true)
        visit auction_path(auction)
        all(".bid-button").first.click
        page.should have_selector('#not-started-modal', visible: true)
      end
    end

    context "after auction start date" do
      it "clicking bid goes to bid page", :js => true do
        auction.update_attributes(:start_time => Time.now, :approved => true)
        visit auction_path(auction)
        all(".bid-button").first.click
        page.should have_selector('.bid-progress-tracker', visible: true)
      end

      context "apply step" do
        it "shows correct reward details", :js => true do
          visit bid_path(auction, reward)
          page.should have_content(reward.title, visible: true)
        end
      end

      context "verify step" do
        before do
          reward.update_attributes(:amount => 13)
          visit bid_path(auction, reward)
          find("body")
          find("#apply-next-button").click
        end

        it "goes to next step if filled in correctly", :js => true do
          fill_in_verify_step_details
          find("#verify-next-button").click
          page.should have_content('Check contact information', visible: true)
        end

        it "does not show hours already bid", :js => true do
          page.should_not have_content("You have already bid", visible: true)
        end

        context "already bid on this reward" do
          set(:bid_1) { FactoryGirl.create :bid, :reward_id => reward.id, :user_id => user.id }
          set(:entry_1) { FactoryGirl.create :hours_entry, :user_id => user.id, :bid_id => bid_1.id, :amount => -10 }
          
          it "shows hours", :js => true do
            page.should have_content("You have already bid 10 hours on this reward.", visible: true)
          end
        end

        context "hours box", :js => true do
          it "shows minimum bid amount as default" do
            page.should have_content("13")
          end

          it "shows hours available to bid" do
            page.should have_content(user.hours_available_to_bid_on(auction))
          end
        end
      end

      context "confirm step with name" do
        before do
          visit bid_path(auction, reward)
          find("body")
          find("#apply-next-button").click
          fill_in_verify_step_details
          find("#verify-next-button").click
        end

        it "shows correct user details including first or last name if provided", :js => true do
          page.should have_content(user.email, visible: true)
          page.should have_content(user.first_name, visible: true)
          page.should have_content(user.last_name, visible: true)
        end

        it "can place bid with first and last name", :js => true do
          expect do
            find("#commit-button").click
            sleep 2
          end.to change(Bid, :count).by(1)
        end

      end

      context "confirm step without name" do
        before do
          user.update_attributes(:first_name => "", :last_name => "")
        end

        it "cannot place bid without first and last name", :js => true do
          expect do
            make_a_bid(auction, reward)
          end.to change(Bid, :count).by(0)
          page.should have_css(".error")
        end
      end
    end

    context "successful bid" do
      it "creates a bid record", :js => true do
        expect do
          make_a_bid(auction, reward)
        end.to change(Bid, :count).by(1)
      end

      it "sends bid confirmation email to bidder after bidding", :js => true do
        make_a_bid(auction, reward)
        mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("Thank you for bidding") }.first
        mail.to.should eq([user.email])
      end

      it "sends bid confirmation email to admin after bidding", :js => true do
        make_a_bid(auction, reward)
        mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("bid on the reward") }.first
        mail.to.should eq(["team@timeauction.org"])
      end

      it "shows after-bid-modal", :js => true do
        make_a_bid(auction, reward)
        page.should have_content("Thank you for bidding", visible: true)
      end

      it "does not show after-bid-modal after it's been seen once", :js => true do
        make_a_bid(auction, reward)
        visit terms_and_conditions_path
        visit auction_path(auction)
        page.should_not have_content("Thank you for bidding", visible: true)
      end
    end
  end

end
