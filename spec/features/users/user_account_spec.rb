require 'spec_helper'

describe "User account" do
  subject { page }
  let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  it "can change account details" do
    facebook_login
    visit edit_user_registration_path
    fill_in :user_first_name, :with => "Sexy New"
    fill_in :user_last_name, :with => "Name"
    click_on "Update"
    page.should have_content("Sexy New Name")
  end
end
