require 'spec_helper'

describe "manage programs" do
  set(:company) { FactoryGirl.create :company_with_programs_and_email_domains }
  set(:user) { FactoryGirl.create :user, :admin => true }

  before do
    login(user)
  end

  context "create" do
    
    before do
      visit new_program_path
    end

    it "program linked to a company" do
      expect do
        fill_in_program_fields(company)
        click_on "Create Program"
      end.to change(Program, :count).by(1)
    end
  end

  context "edit", :js => true do
    set(:different_company) { FactoryGirl.create :company }

    it "changes program name" do
      visit edit_program_path(Program.last)
      fill_in :program_name, :with => "Awesome program"
      click_on "Update Program"
      find("body")
      Program.last.name.should eq("Awesome program")
    end

    it "changes company" do
      program = company.programs.last
      visit edit_program_path(program)
      select "#{different_company.name}", :from => :program_company_id
      click_on "Update Program"
      find("body")
      different_company.programs.last.should eq(program)
    end
  end
end
