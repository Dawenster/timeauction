require 'spec_helper'

describe "not logged in bids", :js => true do
  subject { page }

  set(:creator) { FactoryGirl.create :user }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => creator, :volunteer_start_date => Time.now - 3.months }
  set(:reward) { auction.rewards.first }
  set(:user) { FactoryGirl.create :user, :email => "johndoe2@email.com", :admin => true }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

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
    before do
      auction.update_attributes(:start_time => Time.now, :approved => true)
    end

    it "clicking bid goes to bid page", :js => true do
      visit auction_path(auction)
      all(".bid-button").first.click
      page.should have_selector('.bid-progress-tracker', visible: true)
      page.should_not have_selector('.add-karma-main-button', visible: true)
    end
  end

  context "bid process" do
    it "shows error if not enough hours" do
      visit bid_path(auction, reward)
      page.should_not have_selector(".js-added-error", visible: true)
      find("#apply-next-button").click
      page.should have_selector(".js-added-error", visible: true)
      page.should have_content("You need at least", visible: true)
    end

    context "verify step" do

      context "correct available Karma Points" do
        before do
          reward.update_attributes(:amount => 6)
          visit bid_path(auction, reward)
        end

        it "when adding points from donations" do
          all(".add-karma-section-button")[0].click
          sleep 1
          find("#apply-next-button").click
          within ".hours-remaining-count" do
            page.should have_content("10")
          end
        end

        it "when adding points from hours" do
          all(".add-karma-section-button")[1].click
          all(".add_nested_fields")[0].click
          fill_first_details_of_entry
          fill_in_new_verifier

          find("#apply-next-button").click
          within ".hours-remaining-count" do
            page.should have_content("100")
          end
        end

        it "when adding points from both donations and hours" do
          all(".add-karma-section-button")[0].click
          all(".add-karma-section-button")[1].click
          all(".add_nested_fields")[0].click
          fill_first_details_of_entry
          fill_in_new_verifier

          find("#apply-next-button").click
          within ".hours-remaining-count" do
            page.should have_content("110")
          end
        end
      end

      it "shows points already bid", :js => true do
        bid = Bid.create(:reward_id => reward.id, :user_id => user.id)
        create_existing_hours_entry(user, nonprofit)
        HoursEntry.create(:user_id => user.id, :bid_id => bid.id, :amount => 0, :points => -10, :month => Time.now.month - 1, :year => (Time.now - 1.month).year)
        reward.update_attributes(:amount => 6)
        visit bid_path(auction, reward)
        find("#apply-next-button").click
        
        page.should have_content("you have already bid 10 Karma Points", visible: true)
      end

      context "bid box" do
        before do
          reward.update_attributes(:amount => 6)
          visit bid_path(auction, reward)
          all(".add-karma-section-button")[0].click
          sleep 1
          find("#apply-next-button").click
        end

        it "shows minimum bid amount as default" do
          within ".hours-to-bid" do
            page.should have_content("6")
          end
        end

        it "shows max bid in text" do
          page.should have_content("maximum bid is 100 Karma Points")
        end

        it "clicking down icon does not change bid amount" do
          bid_amount = reward.amount
          find(".fa-toggle-down").click
          within ".hours-to-bid" do
            page.should have_content(bid_amount)
          end
        end

        it "clicking up icon does changes bid amount by +1" do
          bid_amount = reward.amount
          find(".fa-toggle-up").click
          within ".hours-to-bid" do
            page.should have_content(bid_amount.to_i + 1)
          end
        end
      end

      context "max reached" do
        before do
          reward.update_attributes(:amount => 6)
        end

        it "clicking up icon stops when run out of points" do
          create_positive_donations(800, user, nonprofit)
          visit bid_path(auction, reward)
          find("#apply-next-button").click

          bid_amount = reward.amount # 6
          find(".fa-toggle-up").click # 7
          find(".fa-toggle-up").click # 8
          within ".hours-to-bid" do
            page.should have_content(bid_amount.to_i + 2)
          end
          find(".fa-toggle-up").click # Should stay at 15
          within ".hours-to-bid" do
            page.should have_content(bid_amount.to_i + 2)
          end
        end

        it "clicking up icon stops when max allowed reached" do
          create_positive_donations(20000, user, nonprofit)
          visit bid_path(auction, reward)
          find("#apply-next-button").click

          110.times do
            find(".fa-toggle-up").click
          end
          within ".hours-to-bid" do
            page.should have_content("100")
          end
        end
      end
    end

    context "draw checkbox", :js => true do
      context "draw only (default)" do
        before do
          visit bid_path(auction, reward)
          find("body")
          find("#apply-next-button").click
        end

        it "should not show draw check box" do
          page.should_not have_content("Enter me into the draw!", visible: true)
        end

        it "should save with draw as true" do
          finish_bid_from_verify
          expect(Bid.last.enter_draw).to eq(true)
        end
      end

      context "webinar only" do
        before do
          reward.update_attributes(:webinar => true)
          visit bid_path(auction, reward)
          find("body")
          find("#apply-next-button").click
        end

        it "should not show draw check box" do
          page.should_not have_content("Enter me into the draw!", visible: true)
        end

        it "should save with draw as false" do
          finish_bid_from_verify
          expect(Bid.last.enter_draw).to eq(false)
        end
      end

      context "webinar and draw" do
        before do
          reward.update_attributes(:webinar => true, :draw => true)
          visit bid_path(auction, reward)
          find("body")
          find("#apply-next-button").click
        end

        it "should show draw check box" do
          page.should have_content("Enter me into the draw!", visible: true)
        end

        it "check box saves as true" do
          find("#bid_enter_draw").set(true)
          finish_bid_from_verify
          expect(Bid.last.enter_draw).to eq(true)
        end

        it "don't check box saves as false" do
          finish_bid_from_verify
          expect(Bid.last.enter_draw).to eq(false)
        end
      end
    end

    context "confirm step with name" do
      before do
        visit bid_path(auction, reward)
        find("body")
        find("#apply-next-button").click
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
