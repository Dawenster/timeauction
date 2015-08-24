unless Rails.env.production?

  require 'csv'
  require 'nokogiri'
  require 'open-uri'

end

task :collegiatelink => :environment do |t, args|
  time = Time.now

  schools.each do |school|
    begin
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
          begin
            full_club_url = school[:link] + club_url
            doc = Nokogiri::HTML(open(full_club_url))
            club_name = doc.css(".h2__avatarandbutton").text.strip
            puts club_name

            name_div = doc.css(".container-orgcontact ul").first.css("li").last
            dirty_name = name_div.text
            undesired_text_name = name_div.css("h5").text
            club_contact_name = dirty_name.gsub(undesired_text_name, "").strip
            first_club_description = doc.css(".container-orgabout").text.gsub(/\s+/, ' ')

            doc = Nokogiri::HTML(open(full_club_url + "/about"))

            second_club_description = doc.css(".col-xs-12.col-sm-8").first.text.gsub(/\s+/, ' ')
            club_email = doc.css(".col-xs-12.col-sm-4").first.css("div").first.text
            club_email = club_email.gsub("Contact Email", "").strip

            if first_club_description.length > second_club_description.length
              club_description = first_club_description
            else
              club_description = second_club_description
            end

            row_data = [club_name, school[:name], club_contact_name, club_email, full_club_url, club_description]
            csv << row_data
          rescue
            next
          end
        end

        puts "#{(Time.now - time) / 60} minutes"
      end
    rescue
      CSV.open("db/schools/university_clubs/#{school[:name]}-BAD.csv", "wb") do |csv|
        csv << "BAD"
      end
      next
    end
  end

  puts "#{(Time.now - time) / 60} minutes"
end

def schools
  return [
    {:name => 'University of Alberta', :link => 'https://alberta.collegiatelink.net'},
    {:name => 'Berkley', :link => 'https://callink.berkeley.edu'},
    {:name => 'Saint Louis University', :link => 'https://groups.sluconnection.com'},
    {:name => 'Virginia Commonwealth University', :link => 'https://vcu.collegiatelink.net'},
    {:name => 'University of Missouri', :link => 'https://missouristate.collegiatelink.net'},
    {:name => 'Missouri State University', :link => 'https://missouristate.collegiatelink.net'},
    {:name => 'Georgetown University', :link => 'https://hoyalink.georgetown.edu'},
    {:name => 'Kent State University', :link => 'https://u-at-ksu.collegiatelink.net'},
    {:name => 'Northern Arizona University', :link => 'https://nau.collegiatelink.net'},
    {:name => 'University of Arizona', :link => 'https://arizona.collegiatelink.net'}
  ]
end

def url_grab(club_urls, doc)
  doc.css("#results h5 a").each do |header|
    club_urls << header[:href]
  end
end

task :merge_collegiatelink => :environment do |t, args|
  CSV.open("db/schools/merged_university_clubs.csv", "wb") do |csv|
    school_csvs = Dir['db/schools/university_clubs/*.csv']
    school_csvs.each do |school_csv|
      next if dont_merge.include?(school_csv)
      puts school_csv
      CSV.foreach(school_csv) do |row|
        csv << row
        # cleaned_row = row.map do |r|
        #   r.gsub(/\" \n/,"\"\n").gsub(/\\\"/,"__")
        # end
        # csv << cleaned_row
      end
    end
  end
end

def dont_merge
  [
    "db/schools/university_clubs/Berkley.csv",
    "db/schools/university_clubs/Buffalo State University.csv",
    "db/schools/university_clubs/Duke University.csv",
    "db/schools/university_clubs/East Tennessee State University.csv",
    "db/schools/university_clubs/Georgia Gwinnett College.csv",
    "db/schools/university_clubs/Indian University Of Pennsylvania.csv",
    "db/schools/university_clubs/Lake Forest College.csv",
    "db/schools/university_clubs/Lehman College.csv",
    "db/schools/university_clubs/Marquette University.csv",
    "db/schools/university_clubs/Santa Fe College.csv",
    "db/schools/university_clubs/Smith College.csv",
    "db/schools/university_clubs/South Dakota School of Mines & Technology.csv",
    "db/schools/university_clubs/St. Edwards University.csv",
    "db/schools/university_clubs/The University of Utah.csv",
    "db/schools/university_clubs/The University of Vermont.csv",
    "db/schools/university_clubs/Tuskegee University.csv",
    "db/schools/university_clubs/University of Michigan.csv",
    "db/schools/university_clubs/University of Pennsylvania .csv"
  ]
end

















