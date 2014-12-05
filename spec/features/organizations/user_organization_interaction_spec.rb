require 'spec_helper'

describe "user organization interaction", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :sign_in_count => 0 }
  set(:organization) { FactoryGirl.create :sauder_with_programs_and_email_domains }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => organization.programs.first.id, :approved => true, :submitted => true }

  before do
    login(user)
    visit root_path
  end

  context "first time sign in" do
    it "should show organization modal" do
      page.should have_content("You can bid on more auctions if you belong to any of the following organizations", visible: true)
    end
  end

  context "joining organization" do
    it "succeeds" do
      expect do
        all(".organization-selection-holder").first.click
        all(".org-select-input")[1].set("1987")
        all(".save-org-select-button").first.click
        sleep 1
      end.to change(Profile, :count).by(1)
    end

    it "checks required fields" do
      expect do
        all(".organization-selection-holder").first.click
        all(".save-org-select-button").first.click
      end.to change(Profile, :count).by(0)
      page.should have_content("This Field Is Required", visible: true)
    end
  end
end
