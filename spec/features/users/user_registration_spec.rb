require 'spec_helper'

describe "Registration" do
  subject { page }

  context "email signup" do
    context "devise page" do
      it "creates a user" do
        visit new_user_registration_path
        expect do
          within(".main-section") do
            fill_in :user_username, :with => Faker::Internet.user_name
            fill_in :user_email, :with => Faker::Internet.email
            fill_in :user_password, :with => "password"
            within(".hide-for-small-only") do
              click_on 'Sign up'
            end
          end
        end.to change(User, :count).by(1)
      end
    end
  end
end
