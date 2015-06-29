require 'spec_helper'

describe "add karma donations", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

  context "no existing card" do
    before do
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[0].click
    end

    it "shows karma points as soon as section opened" do
      within ".total-karma-to-add" do
        page.should have_content("10")
      end
    end

    it "karma points gone when section closed" do
      within ".total-karma-to-add" do
        page.should have_content("10")
      end
      all(".add-karma-section-button")[0].click
      within ".total-karma-to-add" do
        page.should have_content("0")
      end
    end

    it "$10 pre-selected" do
      expect(find("li.selected").text).to eq("$10")
    end

    it "can change to other pre-selected amounts" do
      dollar_link_25 = all(".amount-list li")[1]
      dollar_link_25.click
      within ".total-karma-to-add" do
        page.should have_content("25")
      end
      expect(find("li.selected")).to eq(dollar_link_25)

      dollar_link_50 = all(".amount-list li")[2]
      dollar_link_50.click
      within ".total-karma-to-add" do
        page.should have_content("50")
      end
      expect(find("li.selected")).to eq(dollar_link_50)

      dollar_link_100 = all(".amount-list li")[3]
      dollar_link_100.click
      within ".total-karma-to-add" do
        page.should have_content("100")
      end
      expect(find("li.selected")).to eq(dollar_link_100)
    end

    context "sliders" do
      it "donations changes value" do
        js_script = "$('.charity-range-slider').val(3)"
        page.execute_script(js_script)

        expect(find(".charity-amount").text).to eq("$3.00")
      end

      it "donations changes tip value correctly" do
        js_script = "$('.charity-range-slider').val(4)"
        page.execute_script(js_script)

        expect(find(".ta-tip-amount").text).to eq("$6.00")
      end

      # it "tip changes value" --> assume this works since cannot have a "set" event listener on both sliders
      # it "tip changes donation value correctly" --> assume this works since cannot have a "set" event listener on both sliders

      it "retains selection ratio after selecting other amounts" do
        js_script = "$('.charity-range-slider').val(8)"
        page.execute_script(js_script)

        dollar_link_25 = all(".amount-list li")[1]
        dollar_link_25.click

        expect(find(".charity-amount").text).to eq("$20.00")
      end
    end

    context "custom amount" do
      before do
        find(".custom-input-text").click
      end

      it "can select and input" do
        find(".custom-input-box").set("82.40")
        within ".total-karma-to-add" do
          page.should have_content("82")
        end
      end

      it "shows Stripe pay amount as different after change amount" do
        find(".custom-input-box").set("82.41")
        click_add_on_add_karma_page
        stripe_iframe = find("iframe.stripe_checkout_app")
        Capybara.within_frame stripe_iframe do
          page.should have_content("Pay CAD $82.41")
        end
      end

      context "errors" do
        it "shows when letter" do
          find(".custom-input-box").set("a")
          within ".total-karma-to-add" do
            page.should have_content("-")
          end
          page.should have_selector('.custom-input-error', visible: true)
          within ".custom-input-error" do
            page.should have_content("Enter a number")
          end
        end

        it "shows when negative" do
          find(".custom-input-box").set("-1")
          within ".total-karma-to-add" do
            page.should have_content("-")
          end
          page.should have_selector('.custom-input-error', visible: true)
          within ".custom-input-error" do
            page.should have_content("Enter a number")
          end
        end

        it "shows when zero" do
          find(".custom-input-box").set("0")
          within ".total-karma-to-add" do
            page.should have_content("-")
          end
          page.should have_selector('.custom-input-error', visible: true)
          within ".custom-input-error" do
            page.should have_content("Be positive")
          end
        end

        it "shows when too large" do
          find(".custom-input-box").set("100000")
          within ".total-karma-to-add" do
            page.should have_content("-")
          end
          page.should have_selector('.custom-input-error', visible: true)
          within ".custom-input-error" do
            page.should have_content("You're being too nice")
          end
        end
      end
    end
  
    it "doesn't show Use Your Card" do
      page.should_not have_selector(".has-default-card-holder", visible: true)
    end

    context "show Stripe" do
      it "prompts Stripe checkout when click 'Add'" do
        click_add_on_add_karma_page
        page.should have_selector("iframe.stripe_checkout_app", visible: true)
      end

      it "shows default Stripe pay amount" do
        click_add_on_add_karma_page
        stripe_iframe = find("iframe.stripe_checkout_app")
        Capybara.within_frame stripe_iframe do
          page.should have_content("Pay CAD $10.00")
        end
      end

      it "shows Stripe pay amount as different after change amount" do
        dollar_link_25 = all(".amount-list li")[1]
        dollar_link_25.click
        click_add_on_add_karma_page
        stripe_iframe = find("iframe.stripe_checkout_app")
        Capybara.within_frame stripe_iframe do
          page.should have_content("Pay CAD $25.00")
        end
      end

      context "makes donation" do
        it "succeeds" do
          click_add_on_add_karma_page
          expect do
            successful_stripe_input
          end.to change(Donation, :count).by(1)
          expect(Donation.last.amount).to eq(1000)
        end

        it "succeeds after changing tip amount" do
          js_script = "$('.charity-range-slider').val(3.45)"
          page.execute_script(js_script)

          click_add_on_add_karma_page
          expect do
            successful_stripe_input
          end.to change(Donation, :count).by(1)
          expect(Donation.last.amount).to eq(1000)
          expect(Donation.last.tip).to eq(655)
        end
      end
    end
  end

  context "existing card" do
    it "by default shows checkbox selected, correct card details, and warning under 'Add'", stripe: { customer: :new, card: :visa } do
      customer = Stripe::Customer.retrieve(stripe_customer.id)
      user.update_attributes(:stripe_cus_id => customer.id)
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[0].click
      page.should have_selector(".has-default-card-holder", visible: true)
      expect(find(".use-existing-card-checkbox").checked?).to eq(true)
      within ".has-default-card-holder" do
        page.should have_content("Visa", visible: true)
        page.should have_content("4242", visible: true)
      end
      page.should have_selector(".will-charge-card-text", visible: true)
    end

    context "checkbox selected" do
      it "donates upon clicking 'Add'", stripe: { customer: :new, card: :mastercard } do
        customer = Stripe::Customer.retrieve(stripe_customer.id)
        user.update_attributes(:stripe_cus_id => customer.id)
        login(user)
        visit add_karma_path
        all(".add-karma-section-button")[0].click
        expect do
          click_add_on_add_karma_page
          sleep 2
        end.to change(Donation, :count).by(1)
        expect(Donation.last.amount).to eq(1000)
      end
    end

    context "checkbox unselected" do
      it "removes warning"

      it "prompts Stripe checkout"
    end
  end
end
