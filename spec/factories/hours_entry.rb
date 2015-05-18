FactoryGirl.define do
  factory :hours_entry do
    amount 10
    organization "Red Cross"
    contact_name "Supervisor Dude"
    contact_phone "123-456-7890"
    contact_email "supervisor@dude.com"
    contact_position "Supervisor"
    month Time.now.month
    year Time.now.year
  end
end
