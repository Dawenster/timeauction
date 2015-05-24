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
    :feature_banner_file_name,
    :feature_banner_content_type,
    :feature_banner_file_size,
    :feature_banner_updated_at,
    :short_description,
    :about,
    :limitations,
    :volunteer_start_date,
    :volunteer_end_date,
    :submitted,
    :video_description,
    :videos,
    :featured,
    :display_order,
    :name,
    :position,
    :on_donor_page,
    :location,
    :tweet,
    :program_id,
    :first_name,
    :sex,
    :draft,
    :feature_sentence,
    :feature_text_colour
  )

  index :as => ActiveAdmin::Views::IndexAsTable do
    column "ID" do |auction|
      link_to auction.id, admin_auction_path(auction)
    end
    column "Edit" do |auction|
      link_to "Edit", edit_admin_auction_path(auction)
    end
    column :name
    column :title
    column :draft
    column :submitted
    column :approved
    column :featured
    column "Program" do |auction|
      link_to auction.program.name, admin_program_path(auction.program) if auction.program
    end
    column :display_order
  end
  
  filter :program, :collection => proc { Program.all.sort_by{|p|p.text_with_organization} }
  filter :name
  filter :title
  filter :location
  filter :draft
  filter :submitted
  filter :approved
  filter :featured
  filter :created_at
  
end
