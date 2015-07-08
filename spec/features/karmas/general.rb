require 'spec_helper'

describe "add karma general", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

  before do
    login(user)
  end

  it "cannot add if nothing selected" do
    visit add_karma_path
    find(".add-karma-main-button").click
    sleep 2
    page.should_not have_selector(".stripeInFrame", visible: true)
  end

  context "shows correct karma" do
    it "from donations only" do
      create_points_from_donations(12, user)
      visit add_karma_path
      page.should have_content("12")
    end

    it "from volunteer hours only" do
      create_points_from_volunteer_hours(7, user, nonprofit)
      visit add_karma_path
      page.should have_content("70")
    end

    it "from donations and volunteer hours" do
      create_points_from_donations(12, user)
      create_points_from_volunteer_hours(7, user, nonprofit)
      visit add_karma_path
      page.should have_content("82")
    end
  end
end
