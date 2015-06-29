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
      fill_first_details_of_entry
      fill_in_new_verifier
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
      fill_first_details_of_entry
      expect do
        click_add_on_add_karma_page
      end.to change(HoursEntry, :count).by(1)
      expect(HoursEntry.last.amount).to eq(10)
      expect(HoursEntry.last.points).to eq(100)
    end

    it "can switch verifier and add" do
      create_existing_hours_entry(user, nonprofit)
      create_another_existing_hours_entry(user, nonprofit)
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click
      fill_first_details_of_entry

      find(".existing-dropdown").find(:xpath, "option[2]").select_option

      expect do
        click_add_on_add_karma_page
      end.to change(HoursEntry, :count).by(1)
      expect(HoursEntry.last.contact_name).to eq("Mama cat")
    end

    it "can switch to new verifier and add" do
      create_existing_hours_entry(user, nonprofit)
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click
      fill_first_details_of_entry

      find(".toggle-new").click

      fill_in_new_verifier

      expect do
        click_add_on_add_karma_page
      end.to change(HoursEntry, :count).by(1)
      expect(HoursEntry.last.contact_name).to eq("Bill Gates")
    end
  end

  it "can add hours from multiple months" do
    create_existing_hours_entry(user, nonprofit)
    login(user)
    visit add_karma_path
    all(".add-karma-section-button")[1].click
    all(".add_nested_fields")[0].click
    fill_first_details_of_entry

    find(".add-more-hours-text").click
    find(".add-more-hours-text").click

    all(".hours").each_with_index do |hour, i|
      hour.set(i + 5)
    end
    all("#date_month").each_with_index do |month, i|
      month.find(:xpath, "option[#{i + 1}]").select_option
    end

    expect do
      click_add_on_add_karma_page
    end.to change(HoursEntry, :count).by(3)
    entries = HoursEntry.order("id desc").limit(3)
    expect(entries.select{|e|e.month == 1}.any?).to eq(true)
    expect(entries.select{|e|e.month == 2}.any?).to eq(true)
    expect(entries.select{|e|e.month == 3}.any?).to eq(true)
  end

  it "can add and remove hours from other months" do
    create_existing_hours_entry(user, nonprofit)
    login(user)
    visit add_karma_path
    all(".add-karma-section-button")[1].click
    all(".add_nested_fields")[0].click
    fill_first_details_of_entry

    find(".add-more-hours-text").click
    find(".add-more-hours-text").click

    all(".hours").each_with_index do |hour, i|
      hour.set(i + 5)
    end
    all("#date_month").each_with_index do |month, i|
      month.find(:xpath, "option[#{i + 1}]").select_option
    end

    all(".close-icon").last.click

    expect do
      click_add_on_add_karma_page
    end.to change(HoursEntry, :count).by(2)
    entries = HoursEntry.order("id desc").limit(2)
    expect(entries.select{|e|e.month == 1}.any?).to eq(true)
    expect(entries.select{|e|e.month == 2}.any?).to eq(true)
    expect(entries.select{|e|e.month == 3}.any?).to eq(false)
  end

  context "errors" do
    before do
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click
    end

    it "can't leave fields blank" do
      page.should_not have_selector(".js-added-error", visible: true)
      click_add_on_add_karma_page
      page.should have_selector(".js-added-error", visible: true)
      expect(all(".js-added-error").count).to eq(7)
    end

    context "hours" do
      it "must be positive" do
        fill_first_details_of_entry
        page.should_not have_selector(".js-added-error", visible: true)
        all(".hours")[0].set("-2")
        page.should have_selector(".js-added-error", visible: true)
        within ".js-added-error" do
          page.should have_content("be positive")
        end
      end

      it "cannot be zero" do
        fill_first_details_of_entry
        page.should_not have_selector(".js-added-error", visible: true)
        all(".hours")[0].set("0")
        page.should have_selector(".js-added-error", visible: true)
        within ".js-added-error" do
          page.should have_content("be positive")
        end
      end

      it "must be a number" do
        fill_first_details_of_entry
        page.should_not have_selector(".js-added-error", visible: true)
        all(".hours")[0].set("a")
        page.should have_selector(".js-added-error", visible: true)
        within ".js-added-error" do
          page.should have_content("please fill in")
        end
      end

      it "can't be too high" do
        fill_first_details_of_entry
        page.should_not have_selector(".js-added-error", visible: true)
        all(".hours")[0].set("745")
        page.should have_selector(".js-added-error", visible: true)
        within ".js-added-error" do
          page.should have_content("check again")
        end
      end
    end

    it "verifier email must be legitimate" do
      fill_first_details_of_entry
      fill_in_new_verifier
      within ".user_hours_entries_contact_email" do
        find("input").set("no good")
      end
      page.should_not have_selector(".js-added-error", visible: true)
      click_add_on_add_karma_page
      page.should have_selector(".js-added-error", visible: true)
      within ".js-added-error" do
        page.should have_content("not an email")
      end
    end
  end

  context "multiple positions" do
    it "succeeds" do
      create_existing_hours_entry(user, nonprofit)
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click
      fill_first_details_of_entry

      all(".add_nested_fields")[0].click

      fill_another_first_details_of_entry

      expect do
        click_add_on_add_karma_page
      end.to change(HoursEntry, :count).by(2)
      entries = HoursEntry.order("id desc").limit(2)
      expect(entries.select{|e|e.organization == "Food bank"}.any?).to eq(true)
      expect(entries.select{|e|e.organization == "Candy town"}.any?).to eq(true)
    end

    it "can remove a newly added position and still succeed" do
      create_existing_hours_entry(user, nonprofit)
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click
      fill_first_details_of_entry

      all(".add_nested_fields")[0].click

      fill_another_first_details_of_entry

      all(".remove_nested_fields")[0].click

      expect do
        click_add_on_add_karma_page
      end.to change(HoursEntry, :count).by(1)
      entries = HoursEntry.order("id desc").limit(1)
      expect(entries.select{|e|e.organization == "Food bank"}.any?).to eq(false)
      expect(entries.select{|e|e.organization == "Candy town"}.any?).to eq(true)
    end

    it "shows errors on newly added form" do
      login(user)
      visit add_karma_path
      all(".add-karma-section-button")[1].click
      all(".add_nested_fields")[0].click
      fill_first_details_of_entry

      all(".add_nested_fields")[0].click

      page.should_not have_selector(".js-added-error", visible: true)
      click_add_on_add_karma_page
      page.should have_selector(".js-added-error", visible: true)
      binding.pry
      expect(all(".js-added-error").count).to eq(11)
    end
  end
end
