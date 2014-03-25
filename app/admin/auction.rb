ActiveAdmin.register Auction do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params(
    :title,
    :approved,
    :description,
    :target,
    :start,
    :end,
    :created_at,
    :updated_at,
    :user_id,
    :banner_file_name,
    :banner_content_type,
    :banner_file_size,
    :banner_updated_at,
    :image_file_name,
    :image_content_type,
    :image_file_size,
    :image_updated_at,
    :short_description,
    :about,
    :limitations,
    :volunteer_end_date,
    :submitted,
    :video_description,
    :videos,
    :featured,
    :order
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
