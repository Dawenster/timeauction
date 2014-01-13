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
    password "password"
  end
end
