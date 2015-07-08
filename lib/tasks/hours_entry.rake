task :send_verification_email, [:hours_entry_id] => :environment do |t, args|
  hours_entry = HoursEntry.find(args.hours_entry_id)
  hours_entry.send_verification_email
end

task :convert_to_points => :environment do |t, args|
  HoursEntry.all.each do |entry|
    entry.update_attributes(:points => entry.amount * 10)
  end
end