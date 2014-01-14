require 'spec_helper'

describe "#create" do
  subject { page }
  let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  before do
    facebook_login
    visit new_auction_path
  end

  it "submits auction", :js => true do
    fill_in :auction_title, :with => "The best auction"
    fill_in :auction_short_description, :with => "If you bid on this, you are smart"
    fill_in :auction_description, :with => "Some longer description..."
    fill_in :auction_about, :with => "This is what we're all about"
    fill_in :auction_start, :with => Time.now.strftime("%b %d, %Y (%a)")
    fill_in :auction_end, :with => (Time.now + 3.days).strftime("%b %d, %Y (%a)")
    fill_in :auction_volunteer_end_date, :with => (Time.now + 1.month).strftime("%b %d, %Y (%a)")
    attach_file :auction_banner, Rails.root + "app/assets/images/nicaragua.jpeg"
    attach_file :auction_image, Rails.root + "app/assets/images/boshin.jpg"
    click_on "Add a reward (max 3)"
    all(".auction_rewards_title").each_with_index do |title, i|
      title.find("input").set("Awesome reward #{i + 1}")
    end
    all(".auction_rewards_description").each_with_index do |description, i|
      description.find("textarea").set("Awesome reward description #{i + 1}")
    end
    all(".auction_rewards_amount").each_with_index do |reward_amount, i|
      reward_amount.find("input").set(20 * (i + 1))
    end
    fill_in :auction_target, :with => 50
    expect do
      click_on "Submit for approval*"
    end.to change(Auction, :count).by(1)
    page.should have_css(".auction-not-yet-approved")
  end
end
