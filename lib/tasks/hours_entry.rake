task :send_verification_email, [:hours_entry_id] => :environment do |t, args|
  hours_entry = HoursEntry.find(args.hours_entry_id)
  HoursEntryMailer.send_verification_email(hours_entry).deliver
end