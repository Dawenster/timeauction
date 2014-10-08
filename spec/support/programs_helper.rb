def fill_in_program_fields(organization)
  fill_in :program_name, :with => Faker::Lorem.sentence
  fill_in :program_description, :with => Faker::Lorem.paragraph
  select "#{organization.name}", :from => :program_organization_id
end