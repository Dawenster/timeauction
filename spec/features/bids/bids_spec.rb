# require 'spec_helper'

# describe "bids" do
#   subject { page }

#   set(:creator) { FactoryGirl.create :user }
#   set(:auction) { FactoryGirl.create :auction_with_rewards, :rewards_count => 2, :user => creator, :volunteer_start_date => Time.now - 3.months }
#   set(:reward) { auction.rewards.first }
#   set(:user) { FactoryGirl.create :user, :email => "johndoe2@email.com", :admin => true }
#   set(:entry_1) { FactoryGirl.create :hours_entry, :amount => 15, :user_id => user.id }

#   context "not logged in" do
#     it "opens signup modal", :js => true do
#       visit auction_path(auction)
#       find("body")
#       all(".bid-button").first.click
#       page.should have_selector('#signup-modal', visible: true)
#     end
#   end

#   context "no hours logged" do
#     before do
#       auction.update_attributes(:approved => true)
#       HoursEntry.destroy_all
#       login(user)
#     end

#     it "opens log hours modal", :js => true do
#       visit auction_path(auction)
#       find("body")
#       all(".bid-button").first.click
#       sleep 1
#       page.should have_selector('#log-hours-modal', visible: true)
#     end
#   end

#   context "not enough hours logged" do
#     before do
#       auction.update_attributes(:approved => true)
#       entry_1.update_attributes(:amount => 3)
#       login(user)
#     end

#     it "opens log hours modal", :js => true do
#       visit auction_path(auction)
#       find("body")
#       all(".bid-button").first.click
#       sleep 1
#       page.should have_selector('#log-hours-modal', visible: true)
#     end
#   end

#   context "logged in" do
#     before do
#       login(user)
#     end

#     context "before auction start date" do
#       it "clicking bid button shows modal", :js => true do
#         auction.update_attributes(:start_time => Time.now + 1.day, :approved => true)
#         visit auction_path(auction)
#         all(".bid-button").first.click
#         page.should have_selector('#not-started-modal', visible: true)
#       end
#     end

#     context "after auction start date" do
#       it "clicking bid goes to bid page", :js => true do
#         auction.update_attributes(:start_time => Time.now, :approved => true)
#         visit auction_path(auction)
#         all(".bid-button").first.click
#         page.should have_selector('.bid-progress-tracker', visible: true)
#       end

#       context "apply step" do
#         it "shows correct reward details", :js => true do
#           visit bid_path(auction, reward)
#           page.should have_content(reward.title, visible: true)
#         end
#       end

#       context "verify step", :js => true do
#         before do
#           reward.update_attributes(:amount => 13)
#           HoursEntry.where("amount < ?", 0).destroy_all
#           visit bid_path(auction, reward)
#           find("body")
#           find("#apply-next-button").click
#         end

#         it "goes to next step if filled in correctly" do
#           fill_in_verify_step_details
#           find("#verify-next-button").click
#           page.should have_content('Check contact information', visible: true)
#         end

#         it "does not show hours already bid" do
#           page.should_not have_content("You have already bid", visible: true)
#         end

#         context "already bid on this reward" do
#           it "shows hours", :js => true do
#             bid = Bid.create(:reward_id => reward.id, :user_id => user.id)
#             HoursEntry.create(:user_id => user.id, :bid_id => bid.id, :amount => -10, :month => Time.now.month - 1, :year => (Time.now - 1.month).year)
#             reward.update_attributes(:amount => 13)
#             visit bid_path(auction, reward)
#             find("body")
#             find("#apply-next-button").click
            
#             page.should have_content("you have already bid 10 hours", visible: true)
#           end
#         end

#         context "hours box" do
#           before do
#             entry_1.update_attributes(:amount => 15)
#           end

#           it "shows minimum bid amount as default" do
#             page.should have_content("13")
#           end

#           it "shows max bid in text" do
#             page.should have_content(25)
#           end

#           it "shows hours available to bid" do
#             page.should have_content(15)
#           end

#           it "clicking down icon does not change bid amount" do
#             bid_amount = reward.amount
#             find(".fa-toggle-down").click
#             within ".hours-to-bid" do
#               page.should have_content(bid_amount)
#             end
#           end

#           it "clicking up icon does changes bid amount by +1" do
#             bid_amount = reward.amount
#             find(".fa-toggle-up").click
#             within ".hours-to-bid" do
#               page.should have_content(bid_amount.to_i + 1)
#             end
#           end

#           it "clicking up icon stops when max reached" do
#             bid_amount = reward.amount # 13
#             find(".fa-toggle-up").click # 14
#             find(".fa-toggle-up").click # 15
#             within ".hours-to-bid" do
#               page.should have_content(bid_amount.to_i + 2)
#             end
#             find(".fa-toggle-up").click # Should stay at 15
#             within ".hours-to-bid" do
#               page.should have_content(bid_amount.to_i + 2)
#             end
#           end
#         end
#       end

#       context "multiple hours entries", :js => true do
#         it "shows correct hours available to bid" do
#           create_positive_entries
#           reward.update_attributes(:amount => 13)
#           visit bid_path(auction, reward)
#           find("body")
#           find("#apply-next-button").click

#           within ".hours-remaining-count" do
#             page.should have_content(22)
#           end
#         end

#         context "after using some" do
#           it "shows correct hours available to bid" do
#             create_positive_entries
#             create_negative_entries
#             reward.update_attributes(:amount => 13)
#             visit bid_path(auction, reward)
#             find("body")
#             find("#apply-next-button").click

#             within ".hours-remaining-count" do
#               page.should have_content(16)
#             end
#           end
#         end
#       end

#       context "premium users", :js => true do
#         it "should show premium text" do
#           reward.update_attributes(:amount => 13)
#           user.update_attributes(:premium => true)
#           visit bid_path(auction, reward)
#           find("body")
#           find("#apply-next-button").click

#           page.should have_content("Time Auction Supporter")
#         end

#         context "multiple hours entries" do
#           it "shows correct hours available to bid" do
#             create_positive_entries
#             reward.update_attributes(:amount => 13)
#             user.update_attributes(:premium => true)
#             visit bid_path(auction, reward)
#             find("body")
#             find("#apply-next-button").click

#             within ".hours-remaining-count" do
#               page.should have_content(30)
#             end
#           end

#           context "after using some" do
#             it "shows correct hours available to bid" do
#               create_positive_entries
#               create_negative_entries
#               reward.update_attributes(:amount => 13)
#               user.update_attributes(:premium => true)
#               visit bid_path(auction, reward)
#               find("body")
#               find("#apply-next-button").click

#               within ".hours-remaining-count" do
#                 page.should have_content(19)
#               end
#             end
#           end
#         end
#       end

#       context "draw checkbox", :js => true do
#         context "draw only (default)" do
#           before do
#             visit bid_path(auction, reward)
#             find("body")
#             find("#apply-next-button").click
#           end

#           it "should not show draw check box" do
#             page.should_not have_content("Enter me into the draw!", visible: true)
#           end

#           it "should save with draw as true" do
#             finish_bid_from_verify
#             expect(Bid.last.enter_draw).to eq(true)
#           end
#         end

#         context "webinar only" do
#           before do
#             reward.update_attributes(:webinar => true)
#             visit bid_path(auction, reward)
#             find("body")
#             find("#apply-next-button").click
#           end

#           it "should not show draw check box" do
#             page.should_not have_content("Enter me into the draw!", visible: true)
#           end

#           it "should save with draw as false" do
#             finish_bid_from_verify
#             expect(Bid.last.enter_draw).to eq(false)
#           end
#         end

#         context "webinar and draw" do
#           before do
#             reward.update_attributes(:webinar => true, :draw => true)
#             visit bid_path(auction, reward)
#             find("body")
#             find("#apply-next-button").click
#           end

#           it "should show draw check box" do
#             page.should have_content("Enter me into the draw!", visible: true)
#           end

#           it "check box saves as true" do
#             find("#bid_enter_draw").set(true)
#             finish_bid_from_verify
#             expect(Bid.last.enter_draw).to eq(true)
#           end

#           it "don't check box saves as false" do
#             finish_bid_from_verify
#             expect(Bid.last.enter_draw).to eq(false)
#           end
#         end
#       end

#       context "confirm step with name" do
#         before do
#           visit bid_path(auction, reward)
#           find("body")
#           find("#apply-next-button").click
#           find("#verify-next-button").click
#         end

#         it "shows correct user details including first or last name if provided", :js => true do
#           page.should have_content(user.email, visible: true)
#           page.should have_content(user.first_name, visible: true)
#           page.should have_content(user.last_name, visible: true)
#         end

#         it "can place bid with first and last name", :js => true do
#           expect do
#             find("#commit-button").click
#             sleep 2
#           end.to change(Bid, :count).by(1)
#         end

#       end

#       context "confirm step without name" do
#         before do
#           user.update_attributes(:first_name => "", :last_name => "")
#         end

#         it "cannot place bid without first and last name", :js => true do
#           expect do
#             make_a_bid(auction, reward)
#           end.to change(Bid, :count).by(0)
#           page.should have_css(".error")
#         end
#       end
#     end

#     context "successful bid" do
#       it "creates a bid record", :js => true do
#         expect do
#           make_a_bid(auction, reward)
#         end.to change(Bid, :count).by(1)
#       end

#       it "sends bid confirmation email to bidder after bidding", :js => true do
#         make_a_bid(auction, reward)
#         mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("Thank you for bidding") }.first
#         mail.to.should eq([user.email])
#       end

#       it "sends bid confirmation email to admin after bidding", :js => true do
#         make_a_bid(auction, reward)
#         mail = ActionMailer::Base.deliveries.select{ |m| m.subject.include?("bid on the reward") }.first
#         mail.to.should eq(["team@timeauction.org"])
#       end

#       it "shows after-bid-modal", :js => true do
#         make_a_bid(auction, reward)
#         page.should have_content("Thank you for bidding", visible: true)
#       end

#       it "does not show after-bid-modal after it's been seen once", :js => true do
#         make_a_bid(auction, reward)
#         visit terms_and_conditions_path
#         visit auction_path(auction)
#         page.should_not have_content("Thank you for bidding", visible: true)
#       end
#     end
#   end

# end
