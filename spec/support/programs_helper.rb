def fill_in_program_fields(organization)
  fill_in :program_name, :with => Faker::Lorem.sentence
  fill_in :program_description, :with => Faker::Lorem.paragraph
  fill_in :program_eligible_period, :with => "between Jan. 1, 2014 and Feb. 28, 2015"
  select "#{organization.name}", :from => :program_organization_id
end