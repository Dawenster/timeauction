ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Users" do
          ul do
            li "Registered users: #{User.count}"
            li "Last 24 hours: #{User.where('created_at > ?', Time.now - 1.day).count}"
            li "Subscribers: #{Subscriber.count('email', :distinct => true)}"
            li "Last 24 hours: #{Subscriber.where('created_at > ?', Time.now - 1.day).count}"
            li "Unique bidders: #{Bid.uniq.pluck(:user_id).count}"
          end
        end
      end

      column do
        panel "Hours" do
          ul do
            li "Hours raised online: #{number_with_delimiter(HoursEntry.total_verified_hours)}"
            li "Hours raised offline: 7,155"
            li "Total hours raised: #{number_with_delimiter(HoursEntry.total_verified_hours + 7155)}"
            li "Hours pending verification: #{number_with_delimiter(HoursEntry.total_hours_pending_verification)}"
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
        organizations = Organization.where(:draft => false)
        organizations.each do |organization|
          panel organization.name do
            overview(organization)
          end
        end
        panel "Public" do
          auction_stats = {
            :bidders => 0,
            :bidders_hrs => 0
          }
          para "* = featured"
          table do
            headers

            tbody do
              Auction.not_corporate.approved.current.custom_order.each do |auction|
                auction_stats = table_details(auction, auction_stats)
              end

              summary_row(auction_stats)
            end
          end
        end
      end
    end
  end # content
end

def overview(org)
  return "No approved auctions yet" unless org.all_approved_auctions.any?
  table do
    headers
    auction_stats = {
      :bidders => 0,
      :bidders_hrs => 0
    }

    tbody do
      org.all_approved_auctions.each do |auction|
        auction_stats = table_details(auction, auction_stats)
      end

      summary_row(auction_stats)
    end
  end
end

def headers
  thead do
    tr do
      th "Order"
      th "Name"
      th "Approved auctions"
      th "Reward"
      th "Max"
      th "Bids"
      th "Hrs raised"
    end
  end
end

def table_details(auction, auction_stats)
  auction.rewards_ordered_by_lowest.each_with_index do |reward, i|
    tr do
      if i == 0
        td "#{auction.display_order}#{'*' if auction.featured}", :style => "border-top: 1px solid lightgrey;"
        td "#{auction.name}", :style => "border-top: 1px solid lightgrey;"
        td "#{auction.title}", :style => "border-top: 1px solid lightgrey;"
      else
        td
        td
        td
      end
      td reward.amount, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
      td reward.max, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
      td reward.num_bidders, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"

      if hk_domain?
        td reward.amount * reward.num_bidders, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
      else
        td reward.hours_raised, :style => "#{'border-top: 1px solid lightgrey;' if i == 0}"
      end

      auction_stats[:bidders] += reward.num_bidders

      if hk_domain?
        auction_stats[:bidders_hrs] += reward.amount * reward.num_bidders
      else
        auction_stats[:bidders_hrs] += reward.hours_raised
      end
    end
  end
  return auction_stats
end

def summary_row(auction_stats)
  tr do
    td "Total", :style => "font-weight: bold; border-top: 1px solid black;"
    td :style => "border-top: 1px solid black;"
    td :style => "border-top: 1px solid black;"
    td :style => "border-top: 1px solid black;"
    td :style => "border-top: 1px solid black;"
    td auction_stats[:bidders], :style => "font-weight: bold; border-top: 1px solid black;"
    td auction_stats[:bidders_hrs], :style => "font-weight: bold; border-top: 1px solid black;"
  end
end
