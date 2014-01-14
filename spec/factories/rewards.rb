FactoryGirl.define do
  sequence :title do |n|
    "#{n}" + Faker::Lorem.sentence
  end

  sequence :description do |n|
    "#{n}" + Faker::Lorem.sentence
  end

  sequence :amount do |n|
    n * 10
  end

  factory :reward do
    title
    description
    amount
  end
end
