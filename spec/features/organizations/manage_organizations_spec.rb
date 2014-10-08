require 'spec_helper'

describe "manage organizations" do
  set(:user) { FactoryGirl.create :user, :admin => true }

  before do
    login(user)
  end

  context "create" do
    before do
      visit new_organization_path
    end

    it "organization with one email domain" do
      expect do
        fill_in_organization_fields
        click_on "Create Organization"
      end.to change(Organization, :count).by(1)
    end

    it "organization with two email domains", :js => true do
      expect do
        fill_in_organization_fields
        click_link "Add an email domain"
        last_field = all("input.string").last
        last_field.set("nike.ca")
        click_on "Create Organization"
      end.to change(EmailDomain, :count).by(2)
    end
  end

  context "edit", :js => true do
    set(:organization) { FactoryGirl.create :organization_with_programs_and_email_domains }

    before do
      visit edit_organization_path(organization)
    end

    it "changes organization name" do
      fill_in :organization_name, :with => "Adidas"
      click_on "Update Organization"
      find("body")
      Organization.last.name.should eq("Adidas")
    end

    it "removes email domain" do
      expect do
        all(".remove_nested_fields").first.click
        click_on "Update Organization"
      end.to change(EmailDomain, :count).by(-1)
    end
  end
end
