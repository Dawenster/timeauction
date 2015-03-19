require 'spec_helper'

describe "email signup" do
  subject { page }
  
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  context "on auction page" do
    set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2 }
    set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => user.id }
    set(:bid_2) { FactoryGirl.create :bid, :reward_id => auction.rewards.last.id, :user_id => user.id }

    before do
      auction.update_attributes(:target => 10)
    end

    context "signed in" do
      before do
        login(user)
        visit auction_path(auction)
      end

      it "subscriber input defaults value with user email", :js => true do
        find_field("subscriber_email").value.should eq(user.email)
      end

      it "can sign up", :js => true do
        expect do
          click_subscribe_on_auction_show
        end.to change(Subscriber, :count).by(1)
        page.should have_content("has been subscribed successfully")
      end
    end

    context "not signed in" do
      before do
        visit auction_path(auction)
      end

      it "can sign up with legit email", :js => true do
        Subscriber.destroy_all
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_subscribe_on_auction_show
        end.to change(Subscriber, :count).by(1)
        page.should have_content("has been subscribed successfully")
      end

      it "cannot sign up with non-legit email", :js => true do
        fill_in :subscriber_email, :with => "notanemail"
        expect do
          click_subscribe_on_auction_show
        end.to change(Subscriber, :count).by(0)
        page.should have_content("Please enter a legitimate email!")
      end

      it "recognizes existing emails", :js => true do
        Subscriber.create(:email => "legitemail@gmail.com")
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_subscribe_on_auction_show
        end.to change(Subscriber, :count).by(0)
        page.should have_content("is already subscribed")
      end
    end
  end

  context "on signup page" do
    context "signed in" do
      before do
        login(user)
        visit email_alerts_path
      end

      it "subscriber input defaults value with user email" do
        find_field("subscriber_email").value.should eq(user.email)
      end

      it "can sign up", :js => true do
        expect do
          click_subscribe_on_subscribe_page
          sleep 1
        end.to change(Subscriber, :count).by(1)
        page.should have_content("has been subscribed successfully")
      end
    end

    context "not signed in" do
      before do
        visit email_alerts_path
      end

      it "can sign up with legit email", :js => true do
        Subscriber.destroy_all
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_subscribe_on_subscribe_page
        end.to change(Subscriber, :count).by(1)
        page.find("body")
        page.should have_content("has been subscribed successfully")
      end

      it "cannot sign up with non-legit email", :js => true do
        fill_in :subscriber_email, :with => "notanemail"
        expect do
          click_subscribe_on_subscribe_page
        end.to change(Subscriber, :count).by(0)
        page.should have_content("Please enter a legitimate email!")
      end

      it "recognizes existing emails", :js => true do
        Subscriber.create(:email => "legitemail@gmail.com")
        fill_in :subscriber_email, :with => "legitemail@gmail.com"
        expect do
          click_subscribe_on_subscribe_page
        end.to change(Subscriber, :count).by(0)
        page.should have_content("is already subscribed")
      end
    end
  end
end
