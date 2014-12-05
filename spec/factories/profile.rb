FactoryGirl.define do
  factory :profile do
    factory :profile_for_sauder do
      program "MBA"
      year "1987"
      identification_number "1234567890"
    end
  end
end
