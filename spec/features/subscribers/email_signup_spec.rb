require 'spec_helper'

describe "email signup" do
  subject { page }

  context "on auction page" do
    let!(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
    let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
    let!(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
    let!(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.last.id, :user_id => user.id }

    before do
      auction.update_attributes(:target => 10)
      visit auction_path(auction)
    end

    context "signed in" do

      before do
        facebook_login
      end

      it "subscriber input defaults value with user email", :js => true do
        find_field("subscriber_email").value.should eq(user.email)
      end

      it "can sign up", :js => true do
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(1)
        page.should have_content("has been added successfully")
      end
    end

    context "not signed in" do
      it "can sign up with legit email", :js => true do
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(1)
        page.should have_content("has been added successfully")
      end

      it "cannot sign up with non-legit email", :js => true do
        fill_in :subscriber_email, :with => "notanemail"
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(0)
        page.should have_content("Please enter a legitimate email!")
      end

      it "recognizes existing emails", :js => true do
        Subscriber.create(:email => "legitemail@gmail.com")
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(0)
        page.should have_content("is already subscribed")
      end
    end
  end

  context "on signup page" do
    before do
      visit email_alerts_path
    end

    context "signed in" do

      let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
      
      before do
        facebook_login
      end

      it "subscriber input defaults value with user email" do
        find_field("subscriber_email").value.should eq(user.email)
      end

      it "can sign up", :js => true do
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(1)
        page.should have_content("has been added successfully")
      end
    end

    context "not signed in" do
      it "can sign up with legit email", :js => true do
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(1)
        page.should have_content("has been added successfully")
      end

      it "cannot sign up with non-legit email", :js => true do
        fill_in :subscriber_email, :with => "notanemail"
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(0)
        page.should have_content("Please enter a legitimate email!")
      end

      it "recognizes existing emails", :js => true do
        Subscriber.create(:email => "legitemail@gmail.com")
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_on "Subscribe"
        end.to change(Subscriber, :count).by(0)
        page.should have_content("is already subscribed")
      end
    end
  end
end
