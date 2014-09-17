require 'spec_helper'

describe "manage companies" do
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
end
