require 'csv'
require 'nokogiri'
require 'open-uri'

task :get_charity_info => :environment do |t, args|
  CSV.open("db/cra/qc1.csv", "wb") do |csv|
    first_page_data = []

    1.upto(165).each do |num|
      begin
        # url = "http://www.cra-arc.gc.ca/ebci/haip/srch/advancedsearchresult-eng.action?n=&b=&q=&s=registered&d=&e=+&c=&v=ON&o=&z=&g=+&t=A&y=+&p=" + num.to_s
        url = "http://www.cra-arc.gc.ca/ebci/haip/srch/advancedsearchresult-eng.action?n=&b=&q=&s=registered&d=&e=+&c=&v=QC&o=&z=&g=+&t=+&y=+&p=" + num.to_s
        doc = Nokogiri::HTML(open(url))
        sleep 1
        puts "Data for page #{num}"
      rescue
        puts "Trying again"
        sleep 3
        doc = Nokogiri::HTML(open(url))
        puts "Data for page #{num}"
        sleep 3
      end

      begin
        doc.css('tr').each_with_index do |row, i|
          next if i == 0

          first_page_data << {
            :city => row.css("td")[3].children.text,
            :link => row.css("a")[0]['href'],
            :page => num.to_s
          }
        end
      rescue
        puts "Give up..."
      end
    end

    first_page_data.each do |data|
      row_data = []

      begin
        begin
          doc = Nokogiri::HTML(open("http://www.cra-arc.gc.ca" + data[:link]))
          # Get name
          name = doc.css("h1").text.gsub(" - Quick View","")
        rescue
          puts "Trying again..."
          doc = Nokogiri::HTML(open("http://www.cra-arc.gc.ca" + data[:link]))
          sleep 1
          # Get name
          name = doc.css("h1").text.gsub(" - Quick View","")
        end

        row_data << name
        puts "Page #{data[:page]}: #{name}"
        row_data << data[:city]

        # Get registered date
        date = doc.css(".qvstatus-date-td").text
        matched_date = date.match /\d{4}-\d{2}-\d{2}/
        row_data << matched_date[0]

        # Get CRA number
        main_paragraph = doc.css(".breakword")
        main_text = main_paragraph.text
        cra_number = main_text.match /\d{9}RR\d{4}/
        row_data << cra_number[0]

        # Get website
        if main_paragraph.css("a").length > 1
          row_data << main_paragraph.css("a")[1]["href"]
        else
          row_data << ""
        end

        # Get numbers
        uls = doc.css(".list-unstyled.legend-ul")
        uls.each do |ul|
          lis = ul.css("li")
          lis.each_with_index do |li, index|
            next if index == 0
            text = li.children.text.match /[$]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?/
            row_data << text[0].gsub("$","").gsub(",","")
          end
        end

        # Get compensation fees
        fees = doc.css(".col-xs-4.col-sm-4.col-md-4.text-right")
        fees.each do |fee|
          row_data << fee.children.text.gsub("$","").gsub(",","").strip!
        end

        csv << row_data
      rescue
      end
    end
  end
end