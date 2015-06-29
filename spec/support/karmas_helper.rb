def click_add_on_add_karma_page
  sleep 1
  find(".add-karma-main-button").click
  sleep 3
end

def successful_stripe_input
  stripe_iframe = find("iframe.stripe_checkout_app")
  Capybara.within_frame stripe_iframe do
    page.execute_script(%Q{ $('input#card_number').val('4242424242424242'); })
    page.execute_script(%Q{ $('input#cc-exp').val('08/44'); })
    page.execute_script(%Q{ $('input#cc-csc').val('999'); })
    page.execute_script(%Q{ $('#submitButton').click(); })
  end
  sleep 5 # allows stripe_checkout_app to submit
end

def create_existing_hours_entry(user, nonprofit)
  HoursEntry.create(
    :amount => 12,
    :points => 120,
    :organization => "Feed the kitties",
    :contact_name => "Mama cat",
    :contact_phone => "123-405-3432",
    :contact_email => "mama@cat.com",
    :contact_position => "Leader of all the cats",
    :month => Date.today.month,
    :year => Date.today.year,
    :user_id => user.id,
    :nonprofit_id => nonprofit.id
  )
end

def create_another_existing_hours_entry(user, nonprofit)
  HoursEntry.create(
    :amount => 9,
    :points => 90,
    :organization => "Feed the puppies",
    :contact_name => "Papa dog",
    :contact_phone => "123-405-3432",
    :contact_email => "papa@dog.com",
    :contact_position => "Leader of all the dogs",
    :month => Date.today.month,
    :year => Date.today.year,
    :user_id => user.id,
    :nonprofit_id => nonprofit.id
  )
end

def fill_first_details_of_entry
  find(".nonprofit-name-autocomplete").set("Food bank")
  within ".user_hours_entries_description" do
    find("textarea").set("I organized lots of food")
  end
  all(".hours")[0].set("10")
end

def fill_in_new_verifier
  within ".user_hours_entries_contact_name" do
    find("input").set("Bill Gates")
  end
  within ".user_hours_entries_contact_position" do
    find("input").set("Da boss")
  end
  within ".user_hours_entries_contact_phone" do
    find("input").set("425-393-3928")
  end
  within ".user_hours_entries_contact_email" do
    find("input").set("bg@ms.com")
  end
end

def fill_another_first_details_of_entry
  all(".nonprofit-name-autocomplete")[1].set("Candy town")
  within all(".user_hours_entries_description")[1] do
    find("textarea").set("I gave out lots of candy")
  end
  all(".hours")[1].set("11")
end

def fill_in_new_verifier
  within ".user_hours_entries_contact_name" do
    find("input").set("Bill Gates")
  end
  within ".user_hours_entries_contact_position" do
    find("input").set("Da boss")
  end
  within ".user_hours_entries_contact_phone" do
    find("input").set("425-393-3928")
  end
  within ".user_hours_entries_contact_email" do
    find("input").set("bg@ms.com")
  end
end