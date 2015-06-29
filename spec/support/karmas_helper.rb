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