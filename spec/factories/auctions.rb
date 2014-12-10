FactoryGirl.define do
  factory :auction do
    name Faker::Name.name
    first_name Faker::Name.name
    sex ["male", "female"].sample
    position Faker::Name.title
    title Faker::Lorem.sentence
    short_description Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    about Faker::Lorem.paragraph
    limitations Faker::Lorem.paragraph
    target 0
    start_time Time.now
    end_time Time.now + 1.week
    volunteer_end_date Time.now + 1.month
    # banner { File.open(banner_root) }
    # image { File.open(image_root) }
    user

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
