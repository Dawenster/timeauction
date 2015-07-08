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

def create_points_from_donations(num, user)
  Donation.create(:amount => num * 100, :user_id => user.id)
end

def create_points_from_volunteer_hours(num, user, nonprofit)
  HoursEntry.create(
    :amount => num,
    :points => num * 10,
    :user_id => user.id,
    :nonprofit_id => nonprofit.id,
    :month => Date.today.month,
    :year => Date.today.year
  )
end