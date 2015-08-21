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

    page_number = 0

    within ".pageHeading-count" do
      club_count = all("strong").last.text.to_i
      page_number = club_count / 10
      if club_count % 10 != 0
        page_number = page_number + 1
      end
    end

    unless page_number <= 1
      2.upto(page_number) do |i|
        visit url + "/?SearchType=None&SelectedCategoryId=0&CurrentPage=" + i.to_s
        url_grab(detailed_pages)
      end
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