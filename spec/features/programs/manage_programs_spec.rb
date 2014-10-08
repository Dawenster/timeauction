require 'spec_helper'

describe "manage programs" do
  set(:organization) { FactoryGirl.create :organization_with_programs_and_email_domains }
  set(:user) { FactoryGirl.create :user, :admin => true }

  before do
    login(user)
  end

  context "create" do
    
    before do
      visit new_program_path
    end

    it "program linked to a organization" do
      expect do
        fill_in_program_fields(organization)
        click_on "Create Program"
      end.to change(Program, :count).by(1)
    end
  end

  context "edit", :js => true do
    set(:different_organization) { FactoryGirl.create :organization }

    it "changes program name" do
      visit edit_program_path(Program.last)
      fill_in :program_name, :with => "Awesome program"
      click_on "Update Program"
      find("body")
      Program.last.name.should eq("Awesome program")
    end

    it "changes organization" do
      program = organization.programs.last
      visit edit_program_path(program)
      select "#{different_organization.name}", :from => :program_organization_id
      click_on "Update Program"
      find("body")
      different_organization.programs.last.should eq(program)
    end
  end
end
