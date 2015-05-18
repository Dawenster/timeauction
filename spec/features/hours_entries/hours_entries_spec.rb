require 'spec_helper'

describe "hours entries" do
  subject { page }

  set(:creator) { FactoryGirl.create :user }
  set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 1, :user => creator }
  set(:user) { FactoryGirl.create :user, :email => "johndoe@email.com" }
  set(:bid_1) { FactoryGirl.create :bid, :reward_id => auction.rewards.first.id, :user_id => 99 }

  before do
    login(user)
  end

  context "can submit hours" do
    context "as premium user" do
      before do
        user.update_attributes(:premium => true, :upgrade_date => Time.now)
      end

      # it "shows submit new hours button", :js => true do
      #   visit user_path(user)
      #   page.should have_content("Submit new hours", visible: true)
      # end

      context "#create", :js => true do
        before do
          visit new_hours_entry_path
        end

        it "is successful" do
          fill_in_hours_entries_form(10)
          fill_in_verifier
          sleep 1
          expect do
            click_button "Submit for verification*"
          end.to change(HoursEntry, :count).by(1)
        end

        it "shows email validation error" do
          fill_in_hours_entries_form(10)
          fill_in_verifier
          fill_in :hours_entry_contact_email, :with => "supervisor@"
          sleep 1
          expect do
            click_button "Submit for verification*"
          end.to change(HoursEntry, :count).by(0)
          page.should have_content("not a valid email")
        end

        it "shows earned hours on #index" do
          fill_in_hours_entries_form(10)
          fill_in_verifier
          sleep 1
          click_button "Submit for verification*"
          page.should have_content("Red Cross", visible: true)
        end
      end

      context "verify hours" do
        before do
          ActionMailer::Base.deliveries = []
          @entry_1 = HoursEntry.new(
            :amount => 100,
            :user_id => user.id,
            :organization => "ABC Org",
            :contact_name => "Mr. ABC",
            :contact_phone => "123-456-7890",
            :contact_email => "abc@gmail.com",
            :contact_position => "Da Boss"
          )
          @entry_1.save(:validate => false)
        end

        it "sends verification email to user" do
          @entry_1.update_attributes(:verified => true)
          mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("Time Auction has verified") }.first
          mail.to.should eq([user.email])
        end

        it "does not send verification email for not verified" do
          @entry_1.update_attributes(:verified => false)
          mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("Time Auction has verified") }.first
          expect(mail).to eq(nil)
        end
      end
    end

    # context "as non-premium user with bids" do

    #   before do
    #     bid_1.update_attributes(:user_id => user.id)
    #     visit "#{user_path(user)}?hk=yes"
    #   end

    #   it "shows submit new hours button for hk" do
    #     page.should have_content("Submit new hours")
    #   end
    # end

  end
end