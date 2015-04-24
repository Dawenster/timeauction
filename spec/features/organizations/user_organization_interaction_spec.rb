require 'spec_helper'

describe "user organization interaction", :js => true do
  subject { page }

  set(:user) { FactoryGirl.create :user, :sign_in_count => 0 }
  set(:organization) { FactoryGirl.create :sauder_with_programs_and_email_domains }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :program_id => organization.programs.first.id, :approved => true, :submitted => true }

  before do
    login(user)
  end

  context "org modal prompt" do
    before do
      visit root_path
      sleep 0.5
    end

    it "shows on first time login" do
      page.should have_content("You can bid on more auctions if you belong to any of the following organizations", visible: true)
    end

    it "does not show if browse to another page" do
      visit auctions_path
      page.should_not have_content("You can bid on more auctions if you belong to any of the following organizations", visible: true)
    end

    it "does not show on subsequent logins" do
      all(".close-reveal-modal").first.click
      logout
      login(user)
      visit root_path
      page.should_not have_content("You can bid on more auctions if you belong to any of the following organizations", visible: true)
    end

    context "orgs to show" do
      set(:non_draft_organization) { FactoryGirl.create :organization_with_programs_and_email_domains, :draft => true }

      it "non-draft orgs only" do
        page.should have_content(organization.name, visible: true)
        page.should_not have_content(non_draft_organization.name, visible: true)
      end
    end
  end

  context "joining organization" do
    before do
      Profile.destroy_all
      visit root_path
      sleep 0.5
    end

    it "succeeds" do
      expect do
        all(".organization-selection-holder").first.click
        all(".org-select-input")[1].set("1987")
        all(".save-org-select-button").first.click
        sleep 1
      end.to change(Profile, :count).by(1)
    end

    it "succeeds with 'Other' selected as dropdown" do
      expect do
        all(".organization-selection-holder").first.click
        select("Other", :from => "program")
        all(".other-field")[0].set("Ma own program yo")
        all(".org-select-input")[2].set("1987")
        all(".save-org-select-button").first.click
        sleep 1
      end.to change(Profile, :count).by(1)
    end

    it "checks required fields" do
      expect do
        all(".organization-selection-holder").first.click
        all(".save-org-select-button").first.click
      end.to change(Profile, :count).by(0)
      page.should have_content("This Field Is Required", visible: true)
    end

    it "shows link icons in top right" do
      all(".organization-selection-holder").first.click
      all(".org-select-input")[1].set("1987")
      all(".save-org-select-button").first.click
      sleep 1
      page.should have_css(".organization-logo-with-border-in-nav")
    end
  end

  context "editing organization" do
    set(:profile) { FactoryGirl.create :profile_for_sauder, :user_id => user.id, :organization_id => organization.id }

    before do
      visit root_path
      sleep 0.5
    end

    it "already shows information filled in" do
      expect(all(".org-select-input")[0].find("option[selected]").text).to eq("MBA")
      expect(all(".org-select-input")[1].value).to eq("1987")
      expect(all(".org-select-input")[2].value).to eq("1234567890")
    end

    it "already shows information filled in if dropdown is other" do
      profile.update_attributes(:program => "Neuroscience")
      profile.reload
      visit edit_user_registration_path
      click_link "Edit organizations"
      sleep 0.5
      expect(all(".org-select-input")[0].find("option[selected]").text).to eq("Other")
      expect(all(".other-field")[0].value).to eq("Neuroscience")
      expect(all(".org-select-input")[2].value).to eq("1987")
      expect(all(".org-select-input")[3].value).to eq("1234567890")
    end

    it "registered newly entered info" do
      all(".org-select-input")[1].set("2014")
      all(".org-select-input")[2].set("ABCDEFG")
      all(".save-org-select-button").first.click
      sleep 1
      profile.reload
      expect(profile.year).to eq("2014")
      expect(profile.identification_number).to eq("ABCDEFG")
    end

    it "does not create more profile records" do
      count = Profile.count
      all(".org-select-input")[1].set("2014")
      all(".org-select-input")[2].set("ABCDEFG")
      all(".save-org-select-button").first.click
      sleep 1
      expect(count).to eq(Profile.count)
    end

    it "allows removal of organization" do
      expect do
        all(".organization-selection-holder").first.click
        all(".save-org-select-button").first.click
        sleep 1
      end.to change(Profile, :count).by(-1)
    end
  end

  context "edit account page" do
    before do
      user.update_attributes(:sign_in_count => 2)
      visit edit_user_registration_path
    end

    it "can show organization modal" do
      click_link "Edit organizations"
      page.should have_content("You can bid on more auctions if you belong to any of the following organizations", visible: true)
    end
  end

  context "on org-specific auction page" do
    before do
      user.update_attributes(:sign_in_count => 2)
      visit auction_path(auction)
    end

    it "prompts org modal if user not part of the auction's org" do
      login(user)
      all(".bid-button").first.click
      page.should have_content("Only #{organization.name} #{organization.people_descriptor} can bid on this auction", visible: true)
    end

    context "user with sauder email" do
      set(:user_with_sauder_email) { FactoryGirl.create :user, :email => "john.doe@sauder.ubc.ca" }

      it "knows user is part of Sauder" do
        expect(user_with_sauder_email.organizations).to eq([organization])
      end

      it "prompts org modal if user didn't fill in all required fields" do
        login(user_with_sauder_email)
        visit auction_path(auction)
        sleep 1
        all(".bid-button").first.click
        page.should have_content("Please fill in all required fields before bidding", visible: true)
      end
    end
  end
end
