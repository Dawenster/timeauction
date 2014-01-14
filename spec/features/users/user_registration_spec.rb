require 'spec_helper'

describe "Registration" do
  subject { page }

  context "email signup" do
    context "devise page" do
      it "creates a user" do
        visit new_user_registration_path
        expect do
          within(".main-section") do
            fill_in_signup_form
            within(".devise-signup-button-holder") do
              click_on 'Sign up'
            end
          end
        end.to change(User, :count).by(1)
      end
    end

    context "modal" do
      before do
        click_nav_login
      end

      it "shows the signup modal", :js => true do
        sleep 1 # give time for the login modal to show
        click_on "Sign up as a new user"
        page.should have_selector('#signup-modal', visible: true)
      end

      it "shows the email signup fields", :js => true do
        sleep 1 # give time for the login modal to show
        click_on "Sign up as a new user"
        click_on "Sign up with email"
        page.should have_selector('#user_username', visible: true)
      end

      it "creates a user" do
        sleep 1 # give time for the login modal to show
        click_on "Sign up as a new user"
        click_on "Sign up with email"

        expect do
          within("#signup-modal") do
            fill_in_signup_form
            within(".signup-by-email") do
              click_on 'Sign up'
            end
          end
        end.to change(User, :count).by(1)
      end
    end
  end

  context "facebook signup" do
    context "devise page" do
      it "creates a user" do
        visit new_user_registration_path
        expect do
          within(".main-section") do
            within(".devise-signup-button-holder") do
              click_on "Sign up with Facebook"
            end
          end
        end.to change(User, :count).by(1)
        page.should have_content("John Doe")
      end
    end

    context "modal" do
      it "creates a user" do
        click_nav_login
        sleep 1 # give time for the login modal to show
        click_on "Sign up as a new user"
        expect do
          click_on "Sign up with Facebook"
        end.to change(User, :count).by(1)
        page.should have_content("John Doe")
      end
    end
  end
end
