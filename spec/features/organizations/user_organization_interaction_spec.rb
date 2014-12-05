require 'spec_helper'

describe "user organization interaction", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :sign_in_count => 0 }
  set(:organization) { FactoryGirl.create :sauder_with_programs_and_email_domains }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => organization.programs.first.id, :approved => true, :submitted => true }

  before do
    login(user)
  end

  context "first time sign in" do
    it "should show organization modal" do
      visit root_path
      page.should have_content("You can bid on more auctions if you belong to any of the following organizations", visible: true)
    end
  end
end
