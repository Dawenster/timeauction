require 'spec_helper'

describe "email signup" do
  subject { page }

  context "on auction page" do
    let!(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
    let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
    let!(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
    let!(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.last.id, :user_id => user.id }

    before do
      visit auction_path(auction)
    end

    context "signed in" do
      let!(:creator) { FactoryGirl.create :user }

    end

    context "not signed in" do

    end
  end

  context "on signup page" do
    before do
      visit email_alerts_path
    end

    context "signed in" do
      let!(:creator) { FactoryGirl.create :user }

      it "can sign up" do

      end
    end

    context "not signed in" do
      it "cannot sign up with non-legit email", :js => true do
        fill_in :subscriber_email, :with => "notanemail"
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(0)
        page.should have_content("Please enter a legitimate email!")
      end
    end
  end
end
