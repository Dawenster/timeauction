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
    :dates
  )

  index :as => ActiveAdmin::Views::IndexAsTable do
    column :id
    column :user
    column :organization
    column :amount
    column :contact_name
    column :contact_phone
    column :contact_email
    column :contact_position
    column :description
    column :created_at
    column :verified
    column :dates
    default_actions
  end

  form do |f|
    f.inputs "Hours Entry" do
      f.input :user, :collection => User.all.map{ |u| u.display_name}.sort
      f.input :bid, :collection => Bid.all.map{ |bid| ["#{bid.user.display_name}: #{bid.reward.title}", bid.id] }.sort
      f.input :amount
      f.input :organization
      f.input :contact_name
      f.input :contact_phone
      f.input :contact_email
      f.input :contact_position
      f.input :description
      f.input :dates
      f.input :verified
    end 
    f.actions

  end
  
  filter :user, :collection => proc { User.all.sort_by{|u|u.display_name} }
  filter :bid, :collection => proc { Bid.all.map{|b|b.id} }
  filter :organization
  filter :amount
  filter :contact_name
  filter :contact_phone
  filter :contact_email
  filter :contact_position
  filter :description
  filter :created_at
  filter :updated_at
  filter :verified
  filter :dates

  csv do
    column :id
    column("User") { |hours_entry| hours_entry.user.display_name }
    column :organization
    column :amount
    column :contact_name
    column :contact_phone
    column :contact_email
    column :contact_position
    column :description
    column :created_at
    column :updated_at
    column :verified
    column :dates
  end
end
