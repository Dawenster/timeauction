unless Rails.env.production?

  require 'rest_client'
  require 'capybara'
  require 'selenium-webdriver'
  require 'csv'
  require 'faker'

end

task :goodcoins => :environment do |t, args|
  time = Time.now
  Capybara.run_server = false
  Capybara.current_driver = :selenium
  include Capybara::DSL

  client = Selenium::WebDriver::Remote::Http::Default.new
  Capybara.register_driver :selenium do |app|
    client.timeout = 36000
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => client)
  end
  invitees = fake_users

  setup_fake_user_emails(invitees)
  login
  go_to_invite_page
  invite(invitees)
  logout(client)
  accept(invitees, client)
  puts "#{(Time.now - time) / 60} minutes"
end

def fake_users
  names = []
  100.times do
    fake_name = Faker::Name.name.split(" ")
    username = "#{fake_name.first.gsub('.','')}#{fake_name.last.gsub(',','')}#{1 + rand(9999)}"
    domain = "rhyta.com"

    names << {
      :first_name => fake_name.first,
      :last_name => fake_name.last,
      :username => username,
      :domain => domain,
      :email => "#{username}@#{domain}"
    }
  end
  return names
end

def setup_fake_user_emails(invitees)
  invitees.each do |invitee|
    email_gen_url = "http://www.fakemailgenerator.com/"
    visit email_gen_url + "inbox/" + invitee[:domain] + "/" + invitee[:username]
  end
end

def login
  goodcoins_url = "https://www.goodcoins.ca"
  visit goodcoins_url

  within ".hug_right.hug_bottom.pad-bottom-10" do
    all("a")[0].click
  end
  
  find("#name").set("david@timeauction.org")
  find("#password").set("asdfasdf")
  find("#signin_submit").click
end

def logout(client)
  client.page.execute_script(%Q{ signOut('/portal/rewards/privacy') })
end

def go_to_invite_page
  goodcoins_offer_url = "https://www.goodcoins.ca/portal/rewards/offers"
  visit goodcoins_offer_url

  square_box = all(".square-content").last
  square_box.click
  find(".btn.float-right").click
end

def invite(invitees)
  invitees.each do |invitee|
    find("#referFriendFirstName").set(invitee[:first_name])
    find("#referFriendLastName").set(invitee[:last_name])
    find("#referFriendEmail").set(invitee[:email])

    within ".hug_bottom.grid-70.tablet-grid-60.mobile-grid-90" do
      find(".btn.float-right").click
    end
  end
end

def accept(invitees, client)
  invitees.each do |invitee|
    begin
      check_email(invitee)
      click_join
      new_sign_up(invitee, client)
    rescue
      next
    end
  end
end

def check_email(invitee)
  email_gen_url = "http://www.fakemailgenerator.com/"
  visit email_gen_url + "inbox/" + invitee[:domain] + "/" + invitee[:username]
  unless has_css?("#emailFrame")
    puts "Waiting for email..."
    sleep 1
  end
end

def click_join
  within_frame "emailFrame" do
    click_link "Join now"
  end
  sleep 5
end

def new_sign_up(invitee, client)
  new_window = client.page.driver.browser.window_handles.last
  client.page.within_window new_window do
    client.page.execute_script(%Q{ glass(signup, 'Connect Me To Group'); })

    find("#signup_firstname").set(invitee[:first_name])
    find("#signup_lastname").set(invitee[:last_name])
    find("#signup_email").set(invitee[:email])
    find("#signup_password").set("asdfasdf")
    find("#signup_confirmPassword").set("asdfasdf")
    find("#signup_birthyear").set("1987")
    find("#signup_birthyear").set("1987")
    client.page.execute_script(%Q{ $("#male").attr("checked", "checked") })
    client.page.execute_script(%Q{ $("#termCheck").attr("checked", "checked") })

    find(".submitButton").click
  end

  sleep 2
  puts "Signed up #{invitee[:email]} :)"

  new_window = client.page.driver.browser.window_handles.last
  client.page.within_window new_window do
    logout(client)
    client.page.execute_script "window.close();"
  end
end