ActiveAdmin.register Auction do
  permit_params(
    :title,
    :approved,
    :description,
    :target,
    :start_time,
    :end_time,
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
    :order,
    :name,
    :position,
    :on_donor_page,
    :location,
    :tweet,
    :program_id,
    :first_name,
    :sex,
    :draft
  )

  index :as => ActiveAdmin::Views::IndexAsTable do
    column :id
    column :name
    column :title
    column :draft
    column :submitted
    column :approved
    column :featured
    column "Program" do |auction|
      link_to auction.program.name, admin_program_path(auction.program) if auction.program
    end
    column :order
  end
  
  filter :program, :collection => proc { Program.all.sort_by{|p|p.text_with_organization} }
  filter :name
  filter :title
  filter :draft
  filter :submitted
  filter :approved
  filter :featured
  filter :created_at
  
end
