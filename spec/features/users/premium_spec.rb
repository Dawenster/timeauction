require 'spec_helper'
require 'stripe_mock'

describe "premium bids", :js => true do
  subject { page }

  set(:creator) { FactoryGirl.create :user }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 1, :user => creator }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  before do
    auction.update_attributes(:target => 10)
    auction.rewards.first.update_attributes(:premium => true)
    login(user)
  end

  context "auctions#show" do
    before do
      visit auction_path(auction)
      page.find("body")
    end

    context "when user has not upgraded" do
      before do
        find(".user-avatar").hover
        find(".non-auction-page-upgrade").click
      end

      context "when reward is premium" do
        it "opens upgrade modal" do
          page.should have_selector('#upgrade-account-modal', visible: true)
        end

        context "within upgrade modal" do
          it "can click 'Upgrade'" do
            find("#upgradeButton").click
            page.within_frame "stripe_checkout_app" do
              page.should have_content('Pay $5.00 per month', visible: true)
            end
          end

          it "can close modal by clicking text" do
            find(".no-thanks-on-premium").click
            page.should_not have_content('Pay $5.00 per month', visible: true)
          end
        end

        context "within upgrade payment modal" do
          before do
            find("#upgradeButton").click
          end

          # it "can close modal by clicking text" do
          #   sleep 1
          #   find(".no-thanks-on-premium").click
          #   sleep 1
          #   page.should_not have_selector('#upgrade-payment-modal', visible: true)
          # end

          # it "can go back a modal" do
          #   sleep 1
          #   find(".back-on-upgrade-payment").click
          #   page.should have_selector('#upgrade-account-modal', visible: true)
          # end

          # it "can switch who to donate to" do
          #   find("#american-red-cross").click
          #   page.should have_content('https://www.redcross.org/quickdonate/index.jsp')
          # end

          # it "can switch the link of who to donate to" do
          #   find(".upgrade-payment-button")[:href].should eq("http://www.redcross.ca/donate")
          #   find("#american-red-cross").click
          #   find(".upgrade-payment-button")[:href].should eq("https://www.redcross.org/quickdonate/index.jsp")
          # end

          context "after completing form" do
            before do
              find(".stripe_checkout_app")
              page.within_frame "stripe_checkout_app" do
                find(".numberInput").set("4242424242424242")
                find(".expiresInput").set("0123")
                find(".cvcInput").set("123")
                click_on "Pay $5.00 per month"
                sleep 5
              end
            end

            it "upgrades the user after clicking 'Donate'" do
              User.last.premium.should eq(true)
            end

            it "sends upgrade confirmation email to user" do
              mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("You have upgraded") }.first
              mail.to.should eq([user.email])
            end

            it "sends notification to admin" do
              mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("Successfully upgraded") }.first
              mail.to.should eq(["team@timeauction.org"])
            end
          end
        end
      end
    end

    context "when user has upgraded" do
      it "opens bid modal" do
        user.update_attributes(:premium => true, :upgrade_date => Time.now)
        all(".bid-button").first.click
        page.should have_selector('#bid-modal', visible: true)
      end
    end
  end

  context "user account page", :js => true do
    context "user upgraded" do
      it "shows the heart icon" do
        user.update_attributes(:premium => true, :upgrade_date => Time.now)
        visit edit_user_registration_path
        page.should have_css(".fa-heart")
      end
    end

    context "user not upgraded" do
      before do
        visit edit_user_registration_path
      end

      it "shows the upgrade button" do
        page.should have_css(".non-auction-page-upgrade")
      end

      it "shows the upgrade modal when upgrade button clicked" do
        find(".non-auction-page-upgrade").click
        page.should have_css("#upgrade-account-modal")
      end

      it "shows different text than the default" do
        find(".non-auction-page-upgrade").click
        page.should have_content("Upgrading your account")
      end
    end
  end

  context "nav-dropdown upgrade link" do
    context "user upgraded" do
      it "does not show link" do
        user.update_attributes(:premium => true, :upgrade_date => Time.now)
        visit root_path
        find(".user-avatar").hover
        page.should_not have_content("Upgrade account", visible: true)
      end
    end

    context "user not upgraded" do
      before do
        visit root_path
      end

      it "shows link" do
        find(".user-avatar").hover
        page.should have_content("Upgrade account", visible: true)
      end

      it "shows the upgrade modal when upgrade button clicked" do
        find(".user-avatar").hover
        find(".non-auction-page-upgrade").click
        page.should have_css("#upgrade-account-modal")
      end
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

  it "generates a stripe card token" do
    card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984)

    cus = Stripe::Customer.create(card: card_token)
    card = cus.cards.data.first
    expect(card.last4).to eq("9191")
    expect(card.exp_year).to eq(1984)
  end
end
