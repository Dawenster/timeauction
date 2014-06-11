# require 'rest_client'
# require 'capybara'
# require 'selenium-webdriver'
# require 'csv'

# task :get_school_info => :environment do |t, args|
#   Capybara.run_server = false
#   Capybara.current_driver = :selenium
#   # Capybara.app_host = "https://www.google.com/flights"
#   include Capybara::DSL

#   home_url = "http://www.tdsb.on.ca/Findyour/School/Byname.aspx"
#   visit home_url
#   school_links = []

#   0.upto(25).each do |num|
#     li = find("#dnn_ctr1658_SchoolSearch_rptLetterNav_liLetter_#{num}")
#     within li do
#       find("a").click
#     end
#     sleep 2
#     schools = all(".SchoolNameLink")
#     schools.each do |school|
#       school_links << school[:href]
#     end
#   end

#   CSV.open("db/schools/tdsb.csv", "wb") do |csv|
#     school_links.each do |link|
#       visit link
#       info = []

#       begin
#         school = find("#dnn_ctr2796_ViewSPC_ctl00_lblSchoolName").text
#         info << school
#       rescue
#         info << ""
#       end
#       begin
#         principal = find("#dnn_ctr2796_ViewSPC_ctl00_lblPrincipal").text
#         info << principal
#       rescue
#         info << ""
#       end
#       begin
#         email = find("#dnn_ctr2796_ViewSPC_ctl00_lnkEMail").text
#         info << email
#       rescue
#         info << ""
#       end

#       csv << info
#     end
#   end
# end

# task :get_secondary_school_info => :environment do |t, args|
#   Capybara.run_server = false
#   Capybara.current_driver = :selenium
#   # Capybara.app_host = "https://www.google.com/flights"
#   include Capybara::DSL

#   home_url = "http://www.tdsb.on.ca/Findyour/School/Secondary.aspx"
#   visit home_url
#   school_links = []

#   schools = all(".SchoolNameLink")
#   schools.each do |school|
#     school_links << school[:href]
#   end

#   CSV.open("db/schools/tdsb_secondary.csv", "wb") do |csv|
#     school_links.each do |link|
#       visit link
#       info = []

#       begin
#         school = find("#dnn_ctr2796_ViewSPC_ctl00_lblSchoolName").text
#         info << school
#       rescue
#         info << ""
#       end
#       begin
#         principal = find("#dnn_ctr2796_ViewSPC_ctl00_lblPrincipal").text
#         info << principal
#       rescue
#         info << ""
#       end
#       begin
#         email = find("#dnn_ctr2796_ViewSPC_ctl00_lnkEMail").text
#         info << email
#       rescue
#         info << ""
#       end

#       csv << info
#     end
#   end
# end