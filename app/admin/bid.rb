ActiveAdmin.register Bid do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :reward_id, :user_id, :application, :message, :premium, :winning
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  index :as => ActiveAdmin::Views::IndexAsTable do
    column :id
    column :user
    column :reward
    column :hours
    column :premium
    column :created_at
    column :application
    column :message
    column :winning
    # if hk_domain?
      column "Confirmation" do |bid|
        if bid.confirmation_sent_at
          "Confirmation sent #{bid.confirmation_sent_at.strftime("%b %d, %Y")}"
        elsif bid.waitlist_sent_at
          "N/A"
        else
          link_to "Send", admin_send_confirmation_email_path(bid), :method => :post, :class => "button"
        end
      end
      column "Waitlist" do |bid|
        if bid.confirmation_sent_at
          "N/A"
        elsif bid.waitlist_sent_at
          "Waitlist sent #{bid.waitlist_sent_at.strftime("%b %d, %Y")}"
        else
          link_to "Send", admin_send_waitlist_email_path(bid), :method => :post, :class => "button"
        end
      end
    # end
    default_actions
  end

  filter :reward, :collection => proc { Reward.all.sort_by{|r|r.title} }
  filter :user, :collection => proc { User.all.sort_by{|u|u.display_name} }
  filter :created_at

  csv do
    column :id
    column("User ID") { |bid| bid.user.id }
    column("First name") { |bid| bid.user.first_name }
    column("Last name") { |bid| bid.user.last_name }
    column("Display Name") { |bid| bid.user.display_name }
    column("User Email") { |bid| bid.user.email }
    column("Reward ID") { |bid| bid.reward.id }
    column("Reward") { |bid| bid.reward.title }
    column("Hours") { |bid| bid.hours }
    column("Premium") { |bid| bid.premium }
    column("Application") { |bid| bid.application }
    column("Message") { |bid| bid.message }
    column("Winning") { |bid| bid.winning }
    column :created_at
    # column :successful?
  end
  
end
