require 'spec_helper'

describe "add karma donations and hours", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

  before do
    login(user)
    visit add_karma_path
    all(".add-karma-section-button")[0].click
    all(".add-karma-section-button")[1].click
    all(".add_nested_fields")[0].click
  end

  it "succeeds" do
    fill_first_details_of_entry
    fill_in_new_verifier

    click_add_on_add_karma_page

    successful_stripe_input

    sleep 2

    expect(Donation.last.amount).to eq(1000)
    expect(HoursEntry.last.amount).to eq(10)
    expect(HoursEntry.last.points).to eq(100)
  end

  it "shows errors" do
    page.should_not have_selector(".js-added-error", visible: true)
    click_add_on_add_karma_page
    page.should have_selector(".js-added-error", visible: true)
  end
end