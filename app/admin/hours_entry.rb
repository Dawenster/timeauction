ActiveAdmin.register HoursEntry do
  permit_params(
    :amount,
    :organization,
    :contact_name,
    :contact_phone,
    :contact_email,
    :contact_position,
    :description,
    :user_id,
    :created_at,
    :updated_at,
    :verified,
    :bid_id,
    :dates,
    :nonprofit_id,
    :month,
    :year,
    :points
  )

  index :as => ActiveAdmin::Views::IndexAsTable do
    column :id
    column :user
    column "Nonprofit" do |hours_entry|
      next if hours_entry.nonprofit.nil?
      link_to hours_entry.nonprofit.name, admin_nonprofit_path(hours_entry.nonprofit)
    end
    column :amount
    column :points
    column :contact_name
    column :contact_phone
    column :contact_email
    column :contact_position
    column :description
    column "Reward" do |hours_entry|
      bid = hours_entry.bid
      link_to bid.reward.title, admin_bid_path(bid.reward) if bid
    end
    column "Reward match" do |hours_entry|
      bid = hours_entry.bid
      bid.user == hours_entry.user if bid
    end
    column :created_at
    column :verified
    column "Date" do |hours_entry|
      if hours_entry.month && hours_entry.year
        "#{Date::MONTHNAMES[hours_entry.month]}, #{hours_entry.year}"
      else
        hours_entry.dates
      end
    end
    column "Send verification" do |hours_entry|
      if hours_entry.earned?
        if hours_entry.verification_sent_at || hours_entry.verified
          "Sent #{hours_entry.verification_sent_at.strftime("%b %d, %Y") if hours_entry.verification_sent_at}"
        else
          link_to "Send", admin_send_verification_email_path(hours_entry.id), :method => :post, :class => "button"
        end
      end
    end
    column "Verify" do |hours_entry|
      link_to "Verify", admin_send_verified_email_path(hours_entry.id), :method => :post, :class => "button" unless hours_entry.verified
    end
    actions
  end

  form do |f|
    f.inputs "Hours Entry" do
      f.input :user, :collection => User.all.map{ |u| [u.display_name, u.id] }.sort
      f.input :bid, :collection => Bid.all.map{ |bid| ["#{bid.user.display_name}: #{bid.reward.title}", bid.id] }.sort
      f.input :amount
      f.input :points
      f.input :nonprofit, :collection => Nonprofit.all.map{ |n| [n.name, n.id]}.sort
      f.input :contact_name
      f.input :contact_phone
      f.input :contact_email
      f.input :contact_position
      f.input :description
      f.input :dates
      f.input :verified
      f.input :month
      f.input :year
    end 
    f.actions

  end
  
  filter :user, :collection => proc { User.all.sort_by{|u|u.display_name} }
  filter :bid, :collection => proc { Bid.all.map{|b|b.id} }
  filter :nonprofit, :collection => proc { Nonprofit.all.map{|n|n.name} }
  filter :amount
  filter :points
  filter :contact_name
  filter :contact_phone
  filter :contact_email
  filter :contact_position
  filter :description
  filter :created_at
  filter :updated_at
  filter :verified, :as => :select
  filter :dates

  csv do
    column :id
    column("User") { |hours_entry| hours_entry.user.display_name }
    column("Nonprofit") { |hours_entry| hours_entry.nonprofit.try(:name) }
    column("Reward") do |hours_entry|
      hours_entry.bid.reward.try(:title) if hours_entry.bid
    end
    column :amount
    column :points
    column :contact_name
    column :contact_phone
    column :contact_email
    column :contact_position
    column :description
    column :created_at
    column :updated_at
    column :verified
    column :dates
    column :month
    column :year
  end
end
