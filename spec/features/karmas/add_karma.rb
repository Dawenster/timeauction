require 'spec_helper'

describe "add karma", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com", :admin => true }

  before do
    login(user)
    visit add_karma_path
  end

  context "general" do
    it "cannot add if nothing selected" do
      find(".add-karma-main-button").click
      sleep 2
      page.should_not have_selector(".stripeInFrame", visible: true)
    end

    it "cannot add if nothing selected"

    it "shows correct current karma"
  end

  context "donations" do
    it "shows karma points as soon as section opened"

    it "karma points gone when section closed"

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
end
