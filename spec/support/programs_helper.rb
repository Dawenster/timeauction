def fill_in_program_fields(company)
  fill_in :program_name, :with => Faker::Lorem.sentence
  fill_in :program_description, :with => Faker::Lorem.paragraph
  select "#{company.name}", :from => :program_company_id
end