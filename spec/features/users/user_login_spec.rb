require 'spec_helper'

describe "Login" do
  subject { page }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }

  context "email login" do
    context "devise page" do
      it "logs in a user" do
        email_login(user)
        page.should have_content(user.display_name)
      end
    end

    context "modal" do
      before do
        click_nav_login
      end

      it "shows the login modal", :js => true do
        page.should have_selector('#login-modal', visible: true)
      end

      it "logs in a user" do
        within("#login-modal") do
          fill_in_login_form(user)
          within(".modal-login-button-holder") do
            click_on 'Login'
          end
        end
        page.should have_content(user.display_name)
      end
    end
  end

  context "facebook login" do
    context "devise page" do
      it "logs in a user" do
        expect do
          facebook_login("devise")
        end.to change(User, :count).by(0)
        page.should have_content("John Doe")
      end
    end

    context "modal" do
      it "logs in a user" do
        facebook_login
        page.should have_content("John Doe")
      end
    end
  end

  context "login from browse page" do
    it "brings user back to referring page", :js => true do
      visit auctions_path
      referrer = current_path
      facebook_login
      expect(referrer).to eq(current_path)
    end
  end
end
