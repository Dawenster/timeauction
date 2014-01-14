def click_nav_login
  visit root_path
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