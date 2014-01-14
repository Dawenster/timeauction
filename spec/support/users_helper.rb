def click_nav_login
  visit root_path unless current_path
  within(".tab-bar") do
    click_on "Login"
  end
end

def fill_in_signup_form
  fill_in :user_username, :with => Faker::Internet.user_name
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