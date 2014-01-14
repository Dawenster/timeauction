FactoryGirl.define do
  factory :auction do
    title Faker::Lorem.sentence
    short_description Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    about Faker::Lorem.paragraph
    limitations Faker::Lorem.paragraph
    target 10
    start Time.now
    self.end Time.now + 1.week
    volunteer_end_date Time.now + 1.month
    banner { fixture_file_upload(banner_root) }
    image { fixture_file_upload(image_root) }
    rewards { Array.new(2) { FactoryGirl.build(:reward) } }
  end
end

# approved
# submitted
