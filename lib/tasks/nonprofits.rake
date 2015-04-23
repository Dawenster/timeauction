require 'csv'

task :seed_nonprofits => :environment do
  CSV.foreach("db/nonprofits/nonprofits.csv") do |row|
    Nonprofit.create(:name => row[0])
  end
end