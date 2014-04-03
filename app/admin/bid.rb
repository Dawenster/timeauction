ActiveAdmin.register Bid do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :reward_id, :user_id
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  ActiveAdmin.register Bid do
    index :as => ActiveAdmin::Views::IndexAsTable do
      column :id
      column :user
      column :reward
      column :hours
      column :created_at
      column :successful?
      default_actions
    end

    filter :reward, :collection => proc { Reward.all.sort_by{|r|r.title} }
    filter :user, :collection => proc { User.all.sort_by{|u|u.display_name} }
    filter :created_at

    csv do
      column :id
      column("User ID") { |bid| bid.user.id }
      column("User") { |bid| bid.user.display_name }
      column("Reward ID") { |bid| bid.reward.id }
      column("Reward") { |bid| bid.reward.title }
      column :created_at
      column :successful?
    end
  end
  
end
