require 'spec_helper'

describe "Registration" do
  subject { page }

  context "email signup" do
    context "devise page" do
      before do
        visit new_user_registration_path
      end

      it "creates a user" do
        expect do
          create_new_user_from_devise_page
        end.to change(User, :count).by(1)
      end

      it "sends a confirmation email" do
        create_new_user_from_devise_page
        ActionMailer::Base.deliveries.last.to.should eq([User.last.email])
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
        click_on "Email"
        page.should have_selector('#user_first_name', visible: true)
      end

      it "creates a user" do
        sleep 1 # give time for the login modal to show
        click_on "Sign up as a new user"
        click_on "Email"

        expect do
          create_new_user_from_modal
        end.to change(User, :count).by(1)
      end

      it "sends a confirmation email" do
        create_new_user_from_modal
        ActionMailer::Base.deliveries.last.to.should eq([User.last.email])
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
              click_on "Facebook"
            end
          end
        end.to change(User, :count).by(1)
        page.should have_content("John Doe")
      end
    end

    context "modal" do
      it "creates a user", js: true do
        click_nav_login
        sleep 1 # give time for the login modal to show
        click_on "Sign up as a new user"
        expect do
          all(".facebook-link")[0].click
        end.to change(User, :count).by(1)
        page.should have_content("John Doe")
      end
    end
  end

  # context "first-time signup upgrade modal", :js => true do
  #   it "shows" do
  #     facebook_login
  #     page.should have_content("Upgrade your account", visible: true)
  #   end

  #   it "does not show after going to second page" do
  #     facebook_login
  #     visit faq_path
  #     page.should_not have_content("Upgrade your account", visible: true)
  #   end

  #   it "does not show after second login" do
  #     facebook_login
  #     find(".no-thanks-on-premium").click
  #     logout
  #     facebook_login
  #     page.should_not have_content("Upgrade your account", visible: true)
  #   end
  # end
end
