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

  form do |f|
    f.inputs "Hours Entry" do
      f.input :user
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
end
