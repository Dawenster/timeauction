require 'spec_helper'

describe "User account" do
  subject { page }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  context "edit account" do

    before do
      login(user)
      visit edit_user_registration_path
    end

    it "can change first and last name" do
      within ".first-last-name" do
        fill_in :user_first_name, :with => "Sexy New"
        fill_in :user_last_name, :with => "Name"
      end
      click_on "Update"
      page.should have_content("Sexy New Name")
    end

    it "can change first name" do
      within(".main-section") do
        fill_in :user_first_name, :with => "sExY vOlUnTeEr"
        fill_in :user_email, :with => "sexy@newemail.com"
      end
      click_on "Update"
      User.first.confirm!
      visit edit_user_registration_path
      within(".main-section") do
        find_field(:user_first_name)
      end.value.should eq("sExY vOlUnTeEr")
      within(".main-section") do
        find_field(:user_email)
      end.value.should eq("sexy@newemail.com")
    end
  end

  context "reset password" do
    it "sends password reset email" do
      visit new_user_password_path
      within(".main-section") do
        fill_in :user_email, :with => "johndoe@email.com"
      end
      click_on "Send me reset password instructions"
      page.should have_content("You will receive an email with instructions")
      ActionMailer::Base.deliveries.last.to.should eq([user.email])
    end
  end

  context "credit card", stripe: { customer: :new, card: :visa }, :js => true do
    before do
      customer = Stripe::Customer.retrieve(stripe_customer.id)
      user.update_attributes(:stripe_cus_id => customer.id)
      login(user)
      visit edit_user_registration_path
    end

    it "shows card details correctly" do
      find(".change-card-link").click
      page.should have_content("Visa (credit) ending in 4242")
    end

    it "updates"

    it "deletable"
  end
end
