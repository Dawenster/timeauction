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

  CSV.open("db/schools/scraped_clubs.csv", "wb") do |csv|
    schools.each do |school|
      club_urls = []

      visit school[:link]
      url_grab(club_urls)

      page_number = 0

      within ".pageHeading-count" do
        club_count = all("strong").last.text.to_i
        page_number = club_count / 10
        if club_count % 10 != 0
          page_number = page_number + 1
        end
      end

      page_number = 2

      unless page_number <= 1
        2.upto(page_number) do |i|
          visit school[:link] + "/?SearchType=None&SelectedCategoryId=0&CurrentPage=" + i.to_s
          url_grab(club_urls)
        end
      end

      club_urls.each do |club_url|
        visit club_url

        club_name = find(".h2__avatarandbutton").text

        club_contact_name = nil 
        within ".container-orgcontact" do
          within all("ul").first do
            club_contact_name = all("li").last.text
            undesired_text_name = find("h5").text
            club_contact_name = club_contact_name.gsub(undesired_text_name, "").strip
          end
        end

        visit club_url + "/about"
        club_description = all(".col-xs-12.col-sm-8").first.text
        club_email = nil
        within all(".col-xs-12.col-sm-4").first do
          club_email = all("div").first.text
          club_email = club_email.gsub("Contact Email", "").strip
        end

        row_data = [club_name, school[:name], club_contact_name, club_email, club_url, club_description]
        csv << row_data
      end
    end
  end

  puts "#{(Time.now - time) / 60} minutes"
end

def schools
  return [
    {
      :name => "University of Michigan",
      :link => "https://maizepages.umich.edu/organizations"
    },
    {
      :name => "Duke University",
      :link => "https://duke.collegiatelink.net/organizations"
    }
  ]
end

def url_grab(club_urls)
  within "#results" do 
    all("h5 a").each do |header|
      club_urls << header[:href]
    end
  end
end