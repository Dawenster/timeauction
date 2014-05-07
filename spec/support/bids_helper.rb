def fill_in_verify_step_details
  fill_in :hours_entry_organization, :with => "Red Cross"
  fill_in :hours_entry_contact_name, :with => "Mrs. Red"
  fill_in :hours_entry_contact_position, :with => "CEO"
  fill_in :hours_entry_contact_phone, :with => "123-456-7890"
  fill_in :hours_entry_contact_email, :with => "red@redcross.org"
  fill_in :hours_entry_description, :with => "I did lots of stuff"
  fill_in :hours_entry_dates, :with => "Every day yo"
end

def make_a_bid
  visit bid_path(auction, reward)
  fill_in :amount, :with => "10"
  find("#bid-next-button").click
  fill_in_verify_step_details
  find("#verify-next-button").click
  fill_in :bid_application, :with => "Cuz I wanna"
  find("#few-words-next-button").click
  find("#commit-button").click
  sleep 2
end