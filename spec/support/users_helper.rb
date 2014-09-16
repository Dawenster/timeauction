def click_nav_login
  visit root_path unless current_path
  within(".tab-bar") do
    click_on "Login"
  end
end

def fill_in_signup_form
  # fill_in :user_username, :with => Faker::Internet.user_name
  fill_in :user_first_name, :with => Faker::Name.first_name
  fill_in :user_last_name, :with => Faker::Name.last_name
  fill_in :user_email, :with => Faker::Internet.email
  fill_in :user_password, :with => "password"
end

def fill_in_login_form(user)
  fill_in :user_email, :with => user.email
  fill_in :user_password, :with => "password"
end

def email_login(user)
  visit new_user_session_path
  within(".main-section") do
    fill_in_login_form(user)
    within(".devise-login-button-holder") do
      click_on 'Login'
    end
  end
end

def facebook_login(location="modal")
  if location == "modal"
    click_nav_login
    within(".modal-login-button-holder") do
      click_on "Login with Facebook"
    end
  else
    visit new_user_session_path
    within(".devise-login-button-holder") do
      click_on "Login with Facebook"
    end
  end
end

def logout
  find(".user-avatar").hover
  click_on "Logout"
end

def create_new_user_from_devise_page
  within(".main-section") do
    fill_in_signup_form
    within(".devise-signup-button-holder") do
      click_on 'Sign up'
    end
  end
end

def create_new_user_from_modal
  within("#signup-modal") do
    fill_in_signup_form
    within(".signup-by-email") do
      click_on 'Sign up'
    end
  end
end