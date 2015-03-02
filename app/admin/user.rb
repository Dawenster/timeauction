ActiveAdmin.register User do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params(
    :email,
    :created_at,
    :updated_at,
    :first_name,
    :last_name,
    :provider,
    :uid,
    :name,
    :timezone,
    :gender,
    :facebook_image,
    :username,
    :premium,
    :upgrade_date,
    :stripe_cus_id,
    :phone_number,
    :admin
  )
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  ActiveAdmin.register User do
    index :as => ActiveAdmin::Views::IndexAsTable do
      column "ID" do |user|
        link_to user.id, admin_user_path(user)
      end
      column :email
      column :first_name
      column :last_name
      column :gender
      column :username
      column "Organization" do |user|
        user.organizations.map do |organization|
          link_to organization.name, admin_organization_path(organization)
        end.join(", ").html_safe
      end
      column :phone_number
      column :volunteer_hours_earned
      column :volunteer_hours_used
      column :hours_left_to_use
      default_actions
    end

    show do |user|
      attributes_table do
        row :first_name
        row :last_name
        row :organization do
          user.organizations.map do |organization|
            link_to organization.name, admin_organization_path(organization)
          end.join(", ").html_safe
        end
        row :username
        row :email
        row :phone_number
        row :volunteer_hours_earned
        row :volunteer_hours_used
        row :hours_left_to_use
        row :bids_made do
          user.bids.map do |bid|
            link_to("#{bid.winning ? 'Won' : 'Lost'}: #{bid.reward.title} (#{bid.hours} #{'hours'.pluralize(bid.hours)})", admin_bid_path(bid))
          end.join(", ").html_safe
        end
        row :premium
        row :upgrade_date
        row :admin
        row :provider
        row :uid
        row :name
        row :timezone
        row :gender
        row :facebook_image
        row :stripe_cus_id
      end
      active_admin_comments
    end

    csv do
      column :id
      column :email
      column :first_name
      column :last_name
      column "Organization(s)" do |user|
        user.organizations.map do |org|
          org.name
        end.to_sentence
      end
      column "Bids" do |user|
        user.bids.map do |bid|
          bid.reward.auction.name
        end.uniq.to_sentence
      end
      column "Bid status" do |user|
        if user.winning_auctions.any?
          "Winner"
        elsif user.bids.any?
          "Bidder"
        end
      end
      column :phone_number
      column :volunteer_hours_earned
      column :volunteer_hours_used
      column :hours_left_to_use
      column :gender
      column :username
      column :premium
      column :upgrade_date
      column :provider
      column :uid
      column :timezone
      column :admin
      column :created_at
    end
  end
end
