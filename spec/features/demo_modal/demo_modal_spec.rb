# require 'spec_helper'

# describe "demo modal" do
#   subject { page }

#   it "displays demo modal", :js => true do
#     visit root_path
#     page.should have_content("Welcome to Time Auction", visible: true)
#   end

#   context "after clicking close" do
#     it "does not display demo modal", :js => true do
#       visit root_path
#       within "#demo-explanation" do
#         find(".close-reveal-modal").click
#       end
#       visit terms_and_conditions_path
#       page.should_not have_content("Welcome to Time Auction", visible: true)
#     end
#   end

#   context "after clicking outside the box" do
#     it "does not display demo modal", :js => true do
#       visit root_path
#       find(".reveal-modal-bg").click
#       visit terms_and_conditions_path
#       page.should_not have_content("Welcome to Time Auction", visible: true)
#     end
#   end

#   context "after clicking let's see the site" do
#     it "does not display demo modal", :js => true do
#       visit root_path
#       within "#demo-explanation" do
#         find(".button").click
#       end
#       visit terms_and_conditions_path
#       page.should_not have_content("Welcome to Time Auction", visible: true)
#     end
#   end
# end
