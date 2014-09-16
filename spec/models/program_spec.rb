require 'spec_helper'

describe Program do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:company_id) }

  context "methods" do
    set(:company) { FactoryGirl.create :company_with_programs_and_email_domains, :name => "Nike" }

    context "#text_with_company" do
      it "returns correct text" do
        program = company.programs.first
        program.text_with_company.should eq("Nike: #{program.name}")
      end
    end
  end
end
