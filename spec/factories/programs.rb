FactoryGirl.define do
  factory :program do
    name Faker::Lorem.sentence
    description Faker::Lorem.paragraph
  end
end
