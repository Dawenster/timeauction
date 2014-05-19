ActiveAdmin.register_page "Round1" do
  content do
    panel "Progress" do
      auctions = Auction.approved.where("created_at < ?", Time.utc(2014,"mar",23,0,0,0))

      table do
        thead do
          tr do
            th "Donor"
            th "Reward (hrs)"
            th "Winner(s)"
            th "Hours done"
            th "Status"
          end
        end

        tbody do
          total_hours_done = 0
          auctions.each do |auction|
            auction.rewards_ordered_by_lowest.each do |reward|
              reward.successful_bidders.each_with_index do |bidder, i|
                tr do
                  if i == 0
                    td "#{auction.name}", :style => "border-top: 1px solid lightgrey;"
                    td "#{reward.title} (#{reward.amount})", :style => "border-top: 1px solid lightgrey;"
                    if bidder
                      td "#{link_to bidder.display_name, admin_user_path(bidder)}".html_safe, :style => "border-top: 1px solid lightgrey;"
                      td "#{bidder.volunteer_hours_earned}", :style => "border-top: 1px solid lightgrey;"
                      td "#{'Done!' if bidder.earned_reward?(reward)}", :style => "border-top: 1px solid lightgrey;"
                    else
                      td ""
                      td ""
                      td ""
                    end
                  else
                    td ""
                    td ""
                    if bidder
                      td "#{link_to bidder.display_name, admin_user_path(bidder)}".html_safe
                      td "#{bidder.volunteer_hours_earned}"
                      td "#{'Done!' if bidder.earned_reward?(reward)}"
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