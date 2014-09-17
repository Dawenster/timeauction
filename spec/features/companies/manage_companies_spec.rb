require 'spec_helper'

describe "manage companies" do
  set(:user) { FactoryGirl.create :user, :admin => true }

  before do
    login(user)
  end

  context "create" do
    before do
      visit new_company_path
    end

    it "company with one email domain" do
      expect do
        fill_in_company_fields
        click_on "Create Company"
      end.to change(Company, :count).by(1)
    end

    it "company with two email domains", :js => true do
      expect do
        fill_in_company_fields
        click_link "Add an email domain"
        last_field = all("input.string").last
        last_field.set("nike.ca")
        click_on "Create Company"
      end.to change(EmailDomain, :count).by(2)
    end
  end

  context "edit", :js => true do
    set(:company) { FactoryGirl.create :company_with_programs_and_email_domains }

    before do
      visit edit_company_path(company)
    end

    it "changes company name" do
      fill_in :company_name, :with => "Adidas"
      click_on "Update Company"
      find("body")
      Company.last.name.should eq("Adidas")
    end

    it "removes email domain" do
      expect do
        all(".remove_nested_fields").first.click
        click_on "Update Company"
      end.to change(EmailDomain, :count).by(-1)
    end
  end
end
