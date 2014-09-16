FactoryGirl.define do
  factory :company do
    company_name = Faker::Name.name
    name company_name
    url company_name.parameterize

    factory :company_with_programs_and_email_domains do
      ignore do
        programs_count 2
        email_domains_count 2
      end

      after(:create) do |company, evaluator|
        create_list(:program, evaluator.programs_count, company: company)
        company.reload
      end

      after(:create) do |company, evaluator|
        create_list(:email_domain, evaluator.email_domains_count, company: company)
        company.reload
      end
    end
  end

end
