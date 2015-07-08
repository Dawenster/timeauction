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

task :send_to_ubc_not_bid_yet => :environment do |t, args|
  ubc_not_bid_yet = []
  CSV.foreach("db/reach_out/ubc_not_bid_yet.csv") do |row|
    ubc_not_bid_yet << {
      :email => row[0],
      :first_name => row[1]
    }
  end

  ubc_not_bid_yet.each do |ubc_user|
    puts "Sending to #{ubc_user[:email]}"
    ReachOutMailer.send_to_ubc_not_bid_yet(ubc_user).deliver
  end
  # ReachOutMailer.send_to_ubc_not_bid_yet(ubc_not_bid_yet.first).deliver
end

task :first_reachout_us_post_secondary => :environment do |t, args|
  us_post_secondary = []
  CSV.foreach("db/reach_out/us_post_secondary.csv") do |row|
    us_post_secondary << {
      :long_name => row[0],
      :first_name => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  us_post_secondary.each do |school|
    puts "Sending to #{school[:email]}"
    ReachOutMailer.first_reachout_us_post_secondary(school).deliver
  end
  # ReachOutMailer.first_reachout_us_post_secondary(us_post_secondary.first).deliver
end

task :first_reachout_ca_post_secondary => :environment do |t, args|
  ca_post_secondary = []
  CSV.foreach("db/reach_out/ca_post_secondary.csv") do |row|
    ca_post_secondary << {
      :long_name => row[0],
      :first_name => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  ca_post_secondary.each do |school|
    puts "Sending to #{school[:email]}"
    ReachOutMailer.first_reachout_ca_post_secondary(school).deliver
  end
  # ReachOutMailer.first_reachout_ca_post_secondary(ca_post_secondary.first).deliver
end

task :first_reachout_us_independent => :environment do |t, args|
  us_independent = []
  CSV.foreach("db/reach_out/us_independent.csv") do |row|
    us_independent << {
      :long_name => row[0],
      :first_name => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  us_independent.each do |school|
    puts "Sending to #{school[:email]}"
    ReachOutMailer.first_reachout_us_independent(school).deliver
  end
  # ReachOutMailer.first_reachout_us_independent(us_independent.first).deliver
end

task :first_reachout_ca_independent => :environment do |t, args|
  ca_independent = []
  CSV.foreach("db/reach_out/ca_independent.csv") do |row|
    ca_independent << {
      :long_name => row[0],
      :first_name => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  ca_independent.each do |school|
    puts "Sending to #{school[:email]}"
    ReachOutMailer.first_reachout_ca_independent(school).deliver
  end
  # ReachOutMailer.first_reachout_ca_independent(ca_independent.first).deliver
end

task :first_reachout_ca_charity => :environment do |t, args|
  ca_charity = []
  CSV.foreach("db/reach_out/ca_charity.csv") do |row|
    ca_charity << {
      :long_name => row[0],
      :first_name => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  ca_charity.each do |charity|
    puts "Sending to #{charity[:email]}"
    ReachOutMailer.first_reachout_ca_charity(charity).deliver
  end
  # ReachOutMailer.first_reachout_ca_charity(ca_charity.sample).deliver
end

task :first_reachout_ca_hospital => :environment do |t, args|
  ca_hospital = []
  CSV.foreach("db/reach_out/ca_hospital.csv") do |row|
    ca_hospital << {
      :long_name => row[0],
      :first_name => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  ca_hospital.each do |hospital|
    puts "Sending to #{hospital[:email]}"
    ReachOutMailer.first_reachout_ca_hospital(hospital).deliver
  end
  # ReachOutMailer.first_reachout_ca_hospital(ca_hospital.sample).deliver
end

task :first_reachout_us_charity => :environment do |t, args|
  us_charity = []
  CSV.foreach("db/reach_out/us_charity.csv") do |row|
    us_charity << {
      :long_name => row[0],
      :first_name => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  us_charity.each do |charity|
    puts "Sending to #{charity[:email]}"
    ReachOutMailer.first_reachout_us_charity(charity).deliver
  end
  # ReachOutMailer.first_reachout_us_charity(us_charity.sample).deliver
end

task :first_reachout_high_school => :environment do |t, args|
  high_schools = []
  CSV.foreach("db/reach_out/high_school_ottawa.csv") do |row|
    high_schools << {
      :long_name => row[0],
      :addressed_to => row[1],
      :short_name => row[2],
      :email => row[3]
    }
  end

  high_schools.each do |school|
    puts "Sending to #{school[:email]}"
    ReachOutMailer.first_reachout_high_school(school).deliver
  end
  # ReachOutMailer.first_reachout_high_school(high_schools.first).deliver
end

task :club_reachout => :environment do |t, args|
  clubs = []
  CSV.foreach("db/reach_out/clubs.csv") do |row|
    clubs << {
      :club_name => row[0],
      :school_name => row[1],
      :first_name => row[2],
      :email => row[3],
      :type => row[4]
    }
  end

  # clubs = [clubs.sample] # Just testing a random one

  clubs.each do |club|
    puts "Sending to #{club[:email]} for #{club[:type]}"
    case club[:type]
    when "Jiwani"
      ReachOutMailer.club_reachout_jiwani(club).deliver
    when "Chris"
      ReachOutMailer.club_reachout_hadfield(club).deliver
    when "Brett"
      ReachOutMailer.club_reachout_wilson(club).deliver
    when "Frank"
      ReachOutMailer.club_reachout_odea(club).deliver
    when "Sam"
      ReachOutMailer.club_reachout_sebastien(club).deliver
    else
      ReachOutMailer.club_reachout_general(club).deliver
    end
  end
end

task :prominent_reachout => :environment do |t, args|
  prominent = []
  CSV.foreach("db/reach_out/prominent.csv") do |row|
    prominent << {
      :first_name => row[0].strip,
      :full_name => row[1].strip,
      :email => row[2].strip,
      :suggestion => row[3].strip,
      :type => row[4].strip,
      :assistant_first_name => "#{row[5].strip if row[5].present?}"
    }
  end

  prominent = [prominent.sample] # Just testing a random one

  prominent.each do |person|
    puts "Sending to #{person[:email]} - #{person[:type]}"
    case person[:type]
    when "Assistant"
      ReachOutMailer.prominent_reachout_assistant(person).deliver
    else
      ReachOutMailer.prominent_reachout(person).deliver
    end
  end
end