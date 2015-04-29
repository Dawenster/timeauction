require 'csv'

task :seed_nonprofits => :environment do
  CSV.foreach("db/nonprofits/nonprofits_hk.csv") do |row|
    Nonprofit.create(:name => row[0].strip)
  end
end

task :match_hours_entry_to_nonprofit => :environment do
  dictionary = {}
  CSV.foreach("db/nonprofits/hours_entry_matching_hk.csv") do |row|
    dictionary[row[0]] = row[1].parameterize
  end

  HoursEntry.all.each do |entry|
    next if entry.organization.blank?
    begin
      puts entry.organization
      nonprofit = Nonprofit.find_by_slug(dictionary[entry.organization])
      entry.update_attributes(:nonprofit_id => nonprofit.id)
    rescue
      puts "ERROR!!!"
    end
  end
end

task :create_roles_table => :environment do
  Nonprofit.all.each do |nonprofit|
    nonprofit.hours_entries.each do |entry|
      unless entry.user_already_has?(nonprofit)
        Role.create(
          :user_id => entry.user.id,
          :nonprofit_id => nonprofit.id
        )
      end
    end
  end
end