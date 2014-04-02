ActiveAdmin.register HoursEntry do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
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
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
