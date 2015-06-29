require 'spec_helper'

describe "add karma volunteer hours", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

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

  it "succeeds with new verifier"

  context "existing verifier" do
    it "succeeds"


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
