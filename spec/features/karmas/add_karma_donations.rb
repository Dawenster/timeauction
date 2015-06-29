require 'spec_helper'

describe "add karma donations", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }
  set(:nonprofit) { FactoryGirl.create :nonprofit }

  before do
    login(user)
  end

  it "shows karma points as soon as section opened" do
    visit add_karma_path
    all(".add-karma-section-button")[0].click
    within ".total-karma-to-add" do
      page.should have_content("10")
    end
  end

  it "karma points gone when section closed" do
    visit add_karma_path
    all(".add-karma-section-button")[0].click
    within ".total-karma-to-add" do
      page.should have_content("10")
    end
    all(".add-karma-section-button")[0].click
    within ".total-karma-to-add" do
      page.should have_content("0")
    end
  end

  it "$10 pre-selected"

  it "can change to other pre-selected amounts"

  it "retains selection ratio after selecting other amounts"

  context "custom amount" do
    it "can select and input"

    context "errors" do
      it "shows when letter"

      it "shows when negative"

      it "shows when too large"
    end
  end

  context "sliders" do
    it "donations changes value"

    it "tip changes value"

    it "donations changes tip value correctly"

    it "tip changes donation value correctly"
  end

  context "no existing card" do
    it "doesn't show Use Your Card"

    it "prompts Stripe checkout when click 'Add'"
  end

  context "existing card" do
    it "shows checkbox already selected as default"

    it "shows correct card details"

    context "checkbox selected" do
      it "shows warning under 'Add'"
    end

    context "checkbox unselected" do
      it "removes warning"

      it "prompts Stripe checkout"
    end
  end
end
