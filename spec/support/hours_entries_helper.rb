def fill_in_hours_entries_form(num)
  fill_in :hours_entry_organization, :with => "Red Cross"
  fill_in :hours_entry_amount, :with => num
  fill_in :hours_entry_contact_name, :with => "Supervisor Dude"
  fill_in :hours_entry_contact_position, :with => "Supervisor"
  fill_in :hours_entry_contact_phone, :with => "123-456-7890"
  fill_in :hours_entry_contact_email, :with => "supervisor@dude.com"
  fill_in :hours_entry_description, :with => Faker::Lorem.paragraph
  fill_in :hours_entry_dates, :with => "Some time"
end