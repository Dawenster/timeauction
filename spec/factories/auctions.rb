FactoryGirl.define do
  factory :auction do
    title Faker::Lorem.sentence
    short_description Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    about Faker::Lorem.paragraph
    limitations Faker::Lorem.paragraph
    target 0
    start Time.now
    self.end Time.now + 1.week
    volunteer_end_date Time.now + 1.month
    banner { fixture_file_upload(banner_root) }
    image { fixture_file_upload(image_root) }

    factory :auction_with_rewards do
      ignore do
        rewards_count 2
      end

      after(:create) do |auction, evaluator|
        create_list(:reward, evaluator.rewards_count, auction: auction)
        auction.reload
      end
    end
  end

end

# approved
# submitted
