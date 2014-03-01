require 'spec_helper'

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
    end

    context "when user has not upgraded" do
      before do
        all(".bid-button").first.click
      end

      context "when reward is premium" do
        it "opens upgrade modal" do
          page.should have_selector('#upgrade-account-modal', visible: true)
        end

        context "within upgrade modal" do
          it "can click 'Upgrade'" do
            find(".upgrade-button").click
            page.should have_selector('#upgrade-payment-modal', visible: true)
          end

          it "can close modal by clicking text" do
            find(".no-thanks-on-premium").click
            page.should_not have_selector('#upgrade-account-modal', visible: true)
          end
        end

        context "within upgrade payment modal" do
          before do
            find(".upgrade-button").click
          end

          it "can close modal by clicking text" do
            sleep 1
            find(".no-thanks-on-premium").click
            sleep 1
            page.should_not have_selector('#upgrade-payment-modal', visible: true)
          end

          it "can go back a modal" do
            sleep 1
            find(".back-on-upgrade-payment").click
            page.should have_selector('#upgrade-account-modal', visible: true)
          end

          it "can switch who to donate to" do
            find("#american-red-cross").click
            page.should have_content('https://www.redcross.org/quickdonate/index.jsp')
          end

          it "can switch the link of who to donate to" do
            find(".upgrade-payment-button")[:href].should eq("http://www.redcross.ca/donate")
            find("#american-red-cross").click
            find(".upgrade-payment-button")[:href].should eq("https://www.redcross.org/quickdonate/index.jsp")
          end

          context "after upgrading (clicking Donate)" do
            before do
              find(".upgrade-payment-button").click
              sleep 1
            end

            it "upgrades the user after clicking 'Donate'" do
              User.last.premium.should eq(true)
            end

            it "sends upgrade confirmation email to user" do
              mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("You have upgraded") }.first
              mail.to.should eq([user.email])
            end

            it "sends notification to admin" do
              mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("upgraded!") }.first
              mail.to.should eq(["team@timeauction.org"])
            end
          end
        end
      end
    end

    context "when user has upgraded" do
      it "opens bid modal" do
        user.update_attributes(:premium => true, :upgrade_date => Time.now)
        sleep 1
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
