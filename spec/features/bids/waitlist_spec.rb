require 'spec_helper'

describe "waitlist bids" do
  subject { page }

  set(:creator) { FactoryGirl.create :user }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 1, :user => creator }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:bidder) { FactoryGirl.create :user }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => bidder.id }

  before do
    auction.update_attributes(:target => 10)
    auction.rewards.first.update_attributes(:max => 1, :limit_bidders => true)
    login(user)
  end

  context "when General Reward" do
    before do
      visit auction_path(auction)
    end

    it "shows 'No more left!' label" do
      page.should have_content("No more left!")
    end

    it "shows 'Join the waitlist' button" do
      page.should have_content("Join the waitlist")
    end

    context "click join waitlist", :js => true do
      before do
        sleep 1
        all(".bid-button").first.click
      end

      it "shows waitlist modal" do
        page.should have_css("#waitlist-modal")
      end

      context "when click 'Yes!'" do
        before do
          find(".waitlist-button").click
        end

        it "shows bid modal" do
          page.should have_css("#bid-modal")
        end

        context "when commit" do
          before do
            click_on "Commit"
            sleep 1
          end

          it "sends email to bidder" do
            mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("You are on the waitlist") }.first
            mail.to.should eq([user.email])
          end

          it "sends email to admin" do
            mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("Waitlist bid") }.first
            mail.to.should eq(["team@timeauction.org"])
          end
        end
      end
    end
  end

  context "when Supporter Reward" do
    it "shows upgrade account modal" do
      auction.rewards.first.update_attributes(:premium => true)
      visit auction_path(auction)
      all(".bid-button").first.click
      find(".waitlist-button").click
      page.should have_css("#upgrade-account-modal")
    end
  end
end
