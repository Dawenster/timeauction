ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Users" do
          ul do
            two_bids = []
            more_than_two_bids = []

            User.select do |user|
              case user.bids.count
              when 2
                two_bids << user
              when 3
                more_than_two_bids << user
              end
            end

            li "Total: #{User.count}"
            li "Last 24 hours: #{User.where('created_at > ?', Time.now - 1.day).count}"
            li "Unique bidders: #{Bid.uniq.pluck(:user_id).count}"
            li "Placed 2 bids: #{two_bids.count} [IDs: #{two_bids.map{|user| link_to user.id, admin_user_path(user)}.join(', ')}]".html_safe
            li "More than 2 bids: #{more_than_two_bids.count} [IDs: #{more_than_two_bids.any? ? more_than_two_bids.map{|user| link_to user.id, admin_user_path(user)}.join(', ') : 'None'}]".html_safe
          end
        end
      end

      column do
        panel "Auctions and rewards" do
          b "Approved"

          ul do
            li "#{Auction.approved.count} auctions"
            li "#{Auction.approved.joins(:rewards).count} rewards"
          end

          b "Pending approval"

          ul do
            li "#{Auction.not_approved.count} auctions"
            li "#{Auction.not_approved.joins(:rewards).count} rewards"
          end
        end
      end
    end

    columns do
      column do
        panel "Overview" do
          para "* = featured"
          table do
            thead do
              tr do
                th "Order"
                th "Approved auctions"
                th "Reward"
                th "Max"
                th "Bids"
                th "Waitlist"
                th "Hrs raised"
                th "Waitlist hrs"
              end
            end

            tbody do
              bidders = 0
              bidders_hrs = 0
              waitlisters = 0
              waitlisters_hrs = 0

              Auction.approved.custom_order.each do |auction|
                auction.rewards_ordered_by_lowest.each_with_index do |reward, i|
                  tr do
                    if i == 0
                      td "#{auction.order}#{'*' if auction.featured}"
                      td "#{auction.title}", :style => "border-top: 1px solid lightgrey;"
                    else
                      td
                      td
                    end
                    td reward.amount, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
                    td reward.max, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
                    td reward.num_successful_bidders, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
                    td reward.num_on_waitlist, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
                    td reward.num_successful_bidders * reward.amount, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
                    td reward.num_on_waitlist * reward.amount, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"

                    bidders += reward.num_successful_bidders
                    bidders_hrs += reward.num_successful_bidders * reward.amount
                    waitlisters += reward.num_on_waitlist
                    waitlisters_hrs += reward.num_on_waitlist * reward.amount
                  end
                end
              end

              tr do
                td "Total", :style => "font-weight: bold; border-top: 1px solid black;"
                td :style => "border-top: 1px solid black;"
                td :style => "border-top: 1px solid black;"
                td bidders, :style => "font-weight: bold; border-top: 1px solid black;"
                td waitlisters, :style => "font-weight: bold; border-top: 1px solid black;"
                td bidders_hrs, :style => "font-weight: bold; border-top: 1px solid black;"
                td waitlisters_hrs, :style => "font-weight: bold; border-top: 1px solid black;"
              end
            end
          end
        end
      end
    end
  end # content
end
