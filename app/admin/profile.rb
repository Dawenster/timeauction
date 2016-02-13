ActiveAdmin.register Profile do

  permit_params :program, :year, :identification_number, :organization_id, :user_id, :department, :location, :data_privacy

  index :as => ActiveAdmin::Views::IndexAsTable do
    column :id
    column "User" do |profile|
      link_to profile.user.display_name, edit_admin_user_path(profile.user)
    end
    column "Organization" do |profile|
      link_to profile.organization.name, edit_admin_organization_path(profile.organization)
    end
    column :program
    column :year
    column :identification_number
    column :department
    column :location
    column :data_privacy
    
    actions
  end

  filter :user, :collection => proc { User.all.sort_by{|u|u.display_name} }
  filter :organization, :collection => proc { Organization.all.sort_by{|o|o.name} }

  csv do
    column :id
    column "User" do |profile|
      profile.user.display_name
    end
    column "Organization" do |profile|
      profile.organization.name
    end
    column :program
    column :year
    column :identification_number
    column :department
    column :location
    column :data_privacy
  end

end
