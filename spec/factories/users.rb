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
    phone_number Faker::PhoneNumber.phone_number
    first_name "John"
    last_name "Doe"
    password "password"
    confirmed_at Time.now
    sign_in_count 2
  end
end
