# require 'nokogiri'
# require 'open-uri'

# task :search, [:domain] => :environment do |t, args|
#   host = "https://www.google.ca/search"
#   url = host + "?hl=en&as_q=email&as_epq=%40#{args.domain}&as_oq=&as_eq=&as_nlo=&as_nhi=&lr=&cr=&as_qdr=all&as_sitesearch=&as_occt=any&safe=images&as_filetype=&as_rights="
#   doc = Nokogiri::HTML(open(URI.encode(url)))

#   sleep 1
#   text = doc.at('body').inner_text
#   emails = text.match /^\s*(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})[\s\/,;]*)+$/i

#   puts "Emails!!"
#   puts emails
# end

require 'rest_client'
require 'capybara'
require 'selenium-webdriver'
require 'csv'

task :search, [:domain] => :environment do |t, args|
  Capybara.run_server = false
  Capybara.current_driver = :selenium
  Capybara.app_host = "https://www.google.com/flights"
  include Capybara::DSL

  url = "https://www.google.ca/search?q=email+%22%40#{args.domain}%22"
  
  all_emails = []

  visit url
  sleep 2

  links = []

  within "#navcnt" do    
    all("td a").each_with_index do |nav_link, i|
      links << nav_link[:href] unless i == 0
    end
  end

  all_emails = fetch_emails_from_page(all_emails)

  links.each do |link|
    visit link
    all_emails = fetch_emails_from_page(all_emails)
  end

  clean_emails = clean_up_emails(all_emails, args.domain)
  clean_emails.each do |key, value|
    puts "============================================"
    puts "Emails ending with: #{key}"
    puts "============================================"
    puts value
  end
end

def fetch_emails_from_page(all_emails)
  all(".st").each do |result|
    text = result.text()
    emails = text.scan /([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})/i
    all_emails << emails if emails.any?
  end
  return all_emails
end

def clean_up_emails(all_emails, domain)
  clean_emails = {}
  clean_emails[domain] = []
  clean_emails["other"] = []

  all_emails.flatten.each do |email|
    if email.match(domain).nil?
      clean_emails["other"] << email.strip
    else
      clean_emails[domain] << email.strip
    end
  end
  clean_emails[domain] = clean_emails[domain].sort.uniq
  clean_emails["other"] = clean_emails["other"].sort.uniq
  return clean_emails
end