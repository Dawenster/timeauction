def click_subscribe_on_auction_show
  within ".subscribe-box" do
    click_on "Subscribe"
    sleep 1
  end
end

def click_subscribe_on_subscribe_page
  within ".new_subscriber" do
    click_on "Subscribe"
  end
end