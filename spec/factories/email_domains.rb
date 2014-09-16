FactoryGirl.define do
  sequence :domain do |n|
    "#{n}" + Faker::Internet.domain_name
  end

  factory :email_domain do
    domain
  end
end
