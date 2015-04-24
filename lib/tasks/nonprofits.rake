require 'csv'

task :seed_nonprofits => :environment do
  CSV.foreach("db/nonprofits/nonprofits.csv") do |row|
    Nonprofit.create(:name => row[0].strip)
  end
end

task :match_hours_entry_to_nonprofit => :environment do
  dictionary = {}
  CSV.foreach("db/nonprofits/hours_entry_matching.csv") do |row|
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