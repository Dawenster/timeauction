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
              reward.winning_bids.each_with_index do |bid, i|
                user = bid.user
                tr do
                  if i == 0
                    td "#{auction.name}", :style => "border-top: 1px solid lightgrey;"
                    td "#{reward.title} (#{reward.amount})", :style => "border-top: 1px solid lightgrey;"
                    td "#{link_to user.display_name, admin_user_path(user)}".html_safe, :style => "border-top: 1px solid lightgrey;"
                    td "#{bid.hours}", :style => "border-top: 1px solid lightgrey;"
                    td "#{'Verified' if bid.verified?}", :style => "border-top: 1px solid lightgrey;"
                  else
                    td ""
                    td ""
                    td "#{link_to user.display_name, admin_user_path(user)}".html_safe
                    td "#{bid.hours}"
                    td "#{'Verified' if bid.verified?}"
                  end
                  total_hours_done += bid.hours
                end

              end
            end
          end
          tr do
            td "Total", :style => "font-weight: bold; border-top: 1px solid black;"
            td :style => "border-top: 1px solid black;"
            td :style => "border-top: 1px solid black;"
            td total_hours_done, :style => "font-weight: bold; border-top: 1px solid black;"
            td :style => "border-top: 1px solid black;"
          end
        end
      end
    end
  end
end