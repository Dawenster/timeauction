require 'spec_helper'

describe Program do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:organization_id) }

  context "methods" do
    set(:organization) { FactoryGirl.create :organization_with_programs_and_email_domains, :name => "Nike" }

    context "#text_with_organization" do
      it "returns correct text" do
        program = organization.programs.first
        program.text_with_organization.should eq("Nike: #{program.name}")
      end
    end
  end
end
