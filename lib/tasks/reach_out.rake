require 'csv'

task :send_to_non_bidders => :environment do |t, args|
  non_bidders = []
  CSV.foreach("db/reach_out/non_bidders.csv") do |row|
    non_bidders << {
      :email => row[0],
      :first_name => row[1],
      :last_name => row[2]
    }
  end

  non_bidders.each do |non_bidder|
    puts "Sending to #{non_bidder[:email]}"
    ReachOutMailer.send_to_non_bidder(non_bidder).deliver
  end
  # ReachOutMailer.send_to_non_bidder(non_bidders.first).deliver
end

task :send_to_subscribers => :environment do |t, args|
  subscribers = []
  CSV.foreach("db/reach_out/subscribers.csv") do |row|
    subscribers << {
      :email => row[0],
      :first_name => row[1],
      :last_name => row[2]
    }
  end

  subscribers.each do |subscriber|
    puts "Sending to #{subscriber[:email]}"
    ReachOutMailer.send_to_subscriber(subscriber).deliver
  end
  # ReachOutMailer.send_to_subscriber(subscribers.first).deliver
end

task :send_to_na_bschools => :environment do |t, args|
  na_bschools = []
  CSV.foreach("db/reach_out/na_bschools.csv") do |row|
    na_bschools << {
      :school_in_title => row[0],
      :school_in_content => row[1],
      :first_name => row[2],
      :email => row[3]
    }
  end

  na_bschools.each do |na_bschool|
    puts "Sending to #{na_bschool[:email]}"
    ReachOutMailer.send_to_na_bschool(na_bschool).deliver
  end
  # ReachOutMailer.send_to_na_bschool(na_bschools.first).deliver
end