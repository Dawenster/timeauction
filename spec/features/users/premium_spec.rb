require 'spec_helper'
require 'stripe_mock'

describe "premium bids", :js => true do
  subject { page }

  set(:creator) { FactoryGirl.create :user }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 1, :user => creator }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  before do
    login(user)
  end

  context "auctions#show" do
    before do
      user.update_attributes(:stripe_cus_id => "cus_3eIKGZ14hhkWCN")
      customer = Stripe::Customer.retrieve(user.stripe_cus_id)
      customer.subscriptions.each do |subscription|
        customer.subscriptions.retrieve(subscription.id).delete()
      end
      visit auction_path(auction)
      page.find("body")
    end

    # context "when user has not upgraded" do
    #   before do
    #     all(".open-upgrade-modal").first.click
    #   end

    #   it "opens upgrade modal" do
    #     page.should have_selector('#upgrade-account-modal', visible: true)
    #   end
        
    #   it "can close modal by clicking text" do
    #     find(".no-thanks-on-premium").click
    #     page.should_not have_content('Pay $', visible: true)
    #   end

    #   it "does not reduce available spots if non-premium user takes a spot" do
    #     reward = auction.rewards.first
    #     reward.update_attributes(:max => 2)
    #     make_a_bid(auction, reward)
    #     reward.spots_available.should eq(2)
    #   end
    # end

    context "successful upgrade" do
      # context "annual charge" do
      #   before do
      #     find("#upgradeButton").click
      #     sleep 2
      #   end

      #   before do
      #     page.within_frame "stripe_checkout_app" do
      #       find(".numberInput").set("4242424242424242")
      #       find(".expiresInput").set("0123")
      #       find(".cvcInput").set("123")
      #       click_on "Pay $"
      #       sleep 5
      #     end
      #   end

      #   it "charged $84 per year" do
      #     customer = Stripe::Customer.retrieve(user.stripe_cus_id)
      #     plan = customer.subscriptions.first.plan
      #     interval = plan.interval
      #     subscription = plan.amount

      #     interval.should eq("year")
      #     subscription.should eq(8400)
      #   end

      # end

      # context "monthly charge" do
      #   before do
      #     # find(".not-selected-billing-period-button").click
      #     find("#upgradeButton").click
      #     sleep 2
      #     stripe_iframe = all('iframe[name=stripe_checkout_app]').last
      #     within_frame stripe_iframe do
      #     # page.within_frame "stripe_checkout_app" do
      #       binding.pry
      #       find(".numberInput").set("4242424242424242")
      #       find(".expiresInput").set("0123")
      #       find(".cvcInput").set("123")
      #       click_on "Pay $"
      #       sleep 7
      #     end
      #   end

      #   it "charged $5 per month" do
      #     customer = Stripe::Customer.retrieve(user.stripe_cus_id)
      #     plan = customer.subscriptions.first.plan
      #     interval = plan.interval
      #     subscription = plan.amount

      #     interval.should eq("month")
      #     subscription.should eq(500)
      #   end

      #   it "sets user as premium" do
      #     User.last.premium.should eq(true)
      #   end
        
      #   it "sends upgrade confirmation email to user" do
      #     mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("You have upgraded") }.first
      #     mail.to.should eq([user.email])
      #   end

      #   it "sends notification to admin" do
      #     mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("Successfully upgraded") }.first
      #     mail.to.should eq(["team@timeauction.org"])
      #   end
      # end
    end

  end

  # context "upgraded users" do
  #   before do
  #     user.update_attributes(:premium => true)
  #   end

    # it "reduces available spots if premium user takes a spot" do
    #   reward = auction.rewards.first
    #   reward.update_attributes(:max => 2)
    #   make_a_bid(auction, reward)
    #   reward.spots_available.should eq(1)
    # end

    # it "can't bid twice after a premium bid" do
    #   reward = auction.rewards.first
    #   make_a_bid(auction, reward)
    #   visit bid_path(auction, reward)
    #   page.should have_content("You have already made a guaranteed bid on this reward!")
    # end
  # end

  context "user account page", :js => true do
    context "user upgraded" do
      it "shows the heart icon" do
        user.update_attributes(:premium => true, :upgrade_date => Time.now)
        visit edit_user_registration_path
        page.should have_css(".fa-heart")
      end
    end
  end

  context "cancelling premium" do
    before do
      user.update_attributes(:premium => true, :upgrade_date => Time.now, :stripe_cus_id => "cus_3eIKGZ14hhkWCN")
      customer = Stripe::Customer.retrieve(user.stripe_cus_id)
      customer.subscriptions.create(:plan => "supporter")
      visit edit_user_registration_path
      find(".unhappy-link").click
      click_on "Cancel upgrade"
      page.driver.browser.switch_to.alert.accept
      find(".alert-box")
    end

    it "can cancel premium subscription" do
      user.reload
      expect(user.premium).to eq(false)
      expect(user.upgrade_date).to eq(nil)
    end

    it "shows correct notice" do
      page.should have_content("Your Supporter Status has been cancelled")
    end
  end
end

describe "Stripe mocks" do
  before { StripeMock.start }
  after { StripeMock.stop }

  it "creates a stripe customer" do
    customer = Stripe::Customer.create({
      email: 'johnny@appleseed.com',
      card: 'void_card_token'
    })
    expect(customer.email).to eq('johnny@appleseed.com')
  end

  it "mocks a declined card error" do
    StripeMock.prepare_card_error(:card_declined)

    expect { Stripe::Charge.create }.to raise_error {|e|
      expect(e).to be_a Stripe::CardError
      expect(e.http_status).to eq(402)
      expect(e.code).to eq('card_declined')
    }
  end

  # it "generates a stripe card token" do
  #   card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984)

  #   cus = Stripe::Customer.create(card: card_token)
  #   card = cus.cards.data.first
  #   expect(card.last4).to eq("9191")
  #   expect(card.exp_year).to eq(1984)
  # end
end
