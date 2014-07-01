ActiveAdmin.register_page "Winners" do
  content do
    panel "Progress" do
      auctions = Auction.approved.past.order("id DESC")

      table do
        thead do
          tr do
            th "Donor"
            th "Reward (hrs)"
            th "Winner(s)"
            th "Hours bid"
            th "Status"
          end
        end

        tbody do
          total_hours_done = 0
          auctions.each do |auction|
            auction.rewards_ordered_by_lowest.each do |reward|
              reward.bids.each_with_index do |bid, i|
                # next if bid.waitlist?
                user = bid.user
                tr do
                  if i == 0
                    td "#{auction.name}", :style => "border-top: 1px solid lightgrey;"
                    td "#{reward.title} (#{reward.amount})", :style => "border-top: 1px solid lightgrey;"
                    if user
                      td "#{link_to user.display_name, admin_user_path(user)}".html_safe, :style => "border-top: 1px solid lightgrey;"
                      td "#{bid.hours}", :style => "border-top: 1px solid lightgrey;"
                      td "#{'Verified' if user.earned_reward?(reward)}", :style => "border-top: 1px solid lightgrey;"
                    else
                      td ""
                      td ""
                      # td ""
                    end
                  else
                    td ""
                    td ""
                    if user
                      td "#{link_to user.display_name, admin_user_path(user)}".html_safe
                      td "#{bid.hours}"
                      td "#{'Verified' if user.earned_reward?(reward)}"
                    else
                      td ""
                      td ""
                      td ""
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end