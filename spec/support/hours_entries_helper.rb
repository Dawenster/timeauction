def fill_in_hours_entries_form(num)
  fill_in :nonprofit_name, :with => "Red Cross"
  fill_in :hours_entry_description, :with => Faker::Lorem.paragraph
  find(".hours").set(num)
end

def fill_in_verifier
  fill_in :hours_entry_contact_name, :with => "Supervisor Dude"
  fill_in :hours_entry_contact_position, :with => "Supervisor"
  fill_in :hours_entry_contact_phone, :with => "123-456-7890"
  fill_in :hours_entry_contact_email, :with => "supervisor@dude.com"
end