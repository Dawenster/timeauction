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
      page.should have_css(".notice")
    end
  end
end
