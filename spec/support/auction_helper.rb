def banner_root
  Rails.root + "app/assets/images/nicaragua.jpeg"
end

def image_root
  Rails.root + "app/assets/images/boshin.jpg"
end

def fill_in_initial_auction_fields
  fill_in :auction_title, :with => "The best auction"
  fill_in :auction_short_description, :with => "If you bid on this, you are smart"
  fill_in :auction_description, :with => "Some longer description..."
  fill_in :auction_about, :with => "This is what we're all about"
  fill_in :auction_start, :with => Time.now.strftime("%b %d, %Y (%a)")
  fill_in :auction_end, :with => (Time.now + 3.days).strftime("%b %d, %Y (%a)")
  fill_in :auction_volunteer_end_date, :with => (Time.now + 1.month).strftime("%b %d, %Y (%a)")
end