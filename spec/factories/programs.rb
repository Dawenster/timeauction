FactoryGirl.define do
  factory :program do
    name Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    eligible_period "between Jan. 1, 2017 and Feb. 28, 2018"
  end
end
