require 'spec_helper'

describe "User account" do
  subject { page }
  let!(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  before do
    facebook_login
    visit edit_user_registration_path
  end

  it "can change first and last name" do
    fill_in :user_first_name, :with => "Sexy New"
    fill_in :user_last_name, :with => "Name"
    click_on "Update"
    page.should have_content("Sexy New Name")
  end

  it "can change username" do
    within(".main-section") do
      fill_in :user_username, :with => "sExY vOlUnTeEr"
      fill_in :user_email, :with => "sexy@newemail.com"
    end
    click_on "Update"
    visit edit_user_registration_path
    within(".main-section") do
      find_field(:user_username)
    end.value.should eq("sexy-volunteer")
    within(".main-section") do
      find_field(:user_email)
    end.value.should eq("sexy@newemail.com")
  end
end
