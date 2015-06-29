require 'spec_helper'

describe "add karma volunteer hours", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

  context "new verifier" do
    before do
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click
    end

    it "autocomplete shows on org name" do
      find(".nonprofit-name-autocomplete").set("re")
      page.should have_selector(".ui-helper-hidden-accessible", :visible => true)
    end

    it "succeeds with new verifier" do
      find(".nonprofit-name-autocomplete").set("Food bank")
      within ".user_hours_entries_description" do
        find("textarea").set("I organized lots of food")
      end
      all(".hours")[0].set("10")
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
      expect do
        click_add_on_add_karma_page
      end.to change(HoursEntry, :count).by(1)
      expect(HoursEntry.last.amount).to eq(10)
      expect(HoursEntry.last.points).to eq(100)
    end
  end

  context "existing verifier" do
    it "succeeds" do
      create_existing_hours_entry(user, nonprofit)
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click

      find(".nonprofit-name-autocomplete").set("Food bank")
      within ".user_hours_entries_description" do
        find("textarea").set("I organized lots of food")
      end
      all(".hours")[0].set("11")
      expect do
        click_add_on_add_karma_page
      end.to change(HoursEntry, :count).by(1)
      expect(HoursEntry.last.amount).to eq(11)
      expect(HoursEntry.last.points).to eq(110)
    end

    it "can switch verifier and add"
  end

  it "can add hours from multiple months"

  it "can add and remove hours from other months"

  context "errors" do
    it "can't leave fields blank"

    context "hours" do
      it "must be positive"

      it "must be a number"

      it "can't be too high"
    end
  end

  context "multiple positions" do
    it "succeeds"

    it "can remove a newly added position and still succeed"

    it "shows errors on newly added form"
  end
end
