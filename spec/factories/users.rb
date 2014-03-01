FactoryGirl.define do
  sequence :username do |n|
    "#{n}" + Faker::Internet.user_name
  end

  sequence :email do |n|
    "#{n}" + Faker::Internet.email
  end

  factory :user do
    username
    email
    first_name "John"
    last_name "Doe"
    password "password"
    confirmed_at Time.now
  end
end
