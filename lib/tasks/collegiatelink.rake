unless Rails.env.production?

  require 'rest_client'
  require 'capybara'
  require 'selenium-webdriver'
  require 'csv'
  require 'faker'

end

task :collegiatelink => :environment do |t, args|
  time = Time.now
  Capybara.run_server = false
  Capybara.current_driver = :selenium
  include Capybara::DSL

  client = Selenium::WebDriver::Remote::Http::Default.new
  Capybara.register_driver :selenium do |app|
    client.timeout = 36000
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => client)
  end

  detailed_pages = []

  urls.each do |url|
    visit url
    url_grab(detailed_pages)
    while next_page_available?
      next_page
      url_grab(detailed_pages)
    end
  end

  puts detailed_pages

  puts "#{(Time.now - time) / 60} minutes"
end

def urls
  return [
    "https://maizepages.umich.edu/organizations",
    "https://duke.collegiatelink.net/organizations"
  ]
end

def url_grab(detailed_pages)
  within "#results" do 
    all("h5 a").each do |header|
      detailed_pages << header[:href]
    end
  end
end

def next_page_available?
  within "#pager" do
    return all("a").last.text == "Next"
  end
end

def next_page
  within "#pager" do
    click_link "Next"
  end
end