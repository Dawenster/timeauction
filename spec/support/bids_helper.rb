def fill_in_verify_step_details
  all("input.string").each do |input|
    input.set("ABC")
  end
  all("textarea.text").each do |input|
    input.set("ABC")
  end
  all("input.email").each do |input|
    input.set("red@redcross.org")
  end
  all("input.numeric").each do |input|
    input.set(3000)
  end
end

def make_a_bid(auction, reward)
  visit bid_path(auction, reward)
  find("body")
  find("#apply-next-button").click
  fill_in_verify_step_details
  find("#verify-next-button").click
  sleep 2
  find("#commit-button").click
  sleep 2
end

def finish_bid_from_verify
  find("#verify-next-button").click
  find("#commit-button").click
  sleep 2
end

def create_positive_entries
  HoursEntry.create(:amount => 7, :user_id => user.id, :month => Time.now.month - 1, :year => (Time.now - 1.month).year)
  HoursEntry.create(:amount => 8, :user_id => user.id, :month => (Time.now - 11.months).month, :year => (Time.now - 11.months).year)
end

def create_negative_entries
  HoursEntry.create(:amount => -6, :user_id => user.id, :month => Time.now.month - 1, :year => (Time.now - 1.month).year)
  HoursEntry.create(:amount => -5, :user_id => user.id, :month => (Time.now - 11.months).month, :year => (Time.now - 11.months).year)
end