unless Rails.env.production?

  require 'csv'
  require 'nokogiri'
  require 'open-uri'

end

task :collegiatelink => :environment do |t, args|
  time = Time.now

  schools.each do |school|
    CSV.open("db/schools/university_clubs/#{school[:name]}.csv", "wb") do |csv|
      club_urls = []

      puts "===================================="
      puts "#{school[:name]}"
      puts "===================================="

      doc = Nokogiri::HTML(open(school[:link] + "/organizations"))
      url_grab(club_urls, doc)

      pages = 0

      club_count = doc.css(".pageHeading-count strong").last.text.to_i
      pages = club_count / 10
      if club_count % 10 != 0
        pages = pages + 1
      end

      puts "Scraping pages for links (#{pages} #{'page'.pluralize(pages)})..."

      # pages = 3

      unless pages <= 1
        2.upto(pages + 1) do |page|
          specific_page_link = school[:link] + "/organizations/?SearchType=None&SelectedCategoryId=0&CurrentPage=" + page.to_s
          doc = Nokogiri::HTML(open(specific_page_link))
          url_grab(club_urls, doc)

          print "\r#{sprintf('%.2f', ((page - 1) / pages.to_f * 100))}% complete"
        end
      end

      puts ""
      puts "Scraping individual club pages..."
      puts "***"

      club_urls.each do |club_url|
        full_club_url = school[:link] + club_url
        doc = Nokogiri::HTML(open(full_club_url))
        begin
          club_name = doc.css(".h2__avatarandbutton").text.strip
          puts club_name

          name_div = doc.css(".container-orgcontact ul").first.css("li").last
          dirty_name = name_div.text
          undesired_text_name = name_div.css("h5").text
          club_contact_name = dirty_name.gsub(undesired_text_name, "").strip

          doc = Nokogiri::HTML(open(full_club_url + "/about"))

          club_description = doc.css(".col-xs-12.col-sm-8").first.text.gsub(/\s+/, ' ')
          club_email = doc.css(".col-xs-12.col-sm-4").first.css("div").first.text
          club_email = club_email.gsub("Contact Email", "").strip

          row_data = [club_name, school[:name], club_contact_name, club_email, full_club_url, club_description]
          csv << row_data
        rescue
          next
        end
      end

      puts "#{(Time.now - time) / 60} minutes"
    end
  end

  puts "#{(Time.now - time) / 60} minutes"
end

def schools
  return [
    # {:name => 'Vanderbilt University', :link => 'https://anchorlink.vanderbilt.edu'},
    # {:name => 'University of Connecticut', :link => 'https://uconntact.uconn.edu'},
    # {:name => 'University of Wyoming', :link => 'https://uwyo.collegiatelink.net'},
    # {:name => 'The University of Alabama', :link => 'https://ua.collegiatelink.net'},
    # {:name => 'Pepperdine University', :link => 'https://pepperdine.collegiatelink.net'}
    {:name => 'Brunswick Community College', :link => 'https://rutgers.collegiatelink.net'},
    {:name => 'University of Pennsylvania ', :link => 'https://iup.collegiatelink.net'},
    {:name => 'The University of Utah', :link => 'https://tbirdconnection.collegiatelink.net'},
    {:name => 'Towson University', :link => 'https://involved.towson.edu'},
    {:name => 'Kean University', :link => 'https://kean.collegiatelink.net'}
  ]
end

def url_grab(club_urls, doc)
  doc.css("#results h5 a").each do |header|
    club_urls << header[:href]
  end
end