ActiveAdmin.register Role do
  permit_params(
    :title,
    :description,
    :created_at,
    :updated_at
  )

  index :as => ActiveAdmin::Views::IndexAsTable do
    column :id
    column :user
    column :nonprofit
    column :title
    column :description
    actions
  end


  csv do
    column :id
    column "User ID" do |role|
      role.user.id
    end
    column "User" do |role|
      role.user.display_name
    end
    column "Nonprofit ID" do |role|
      role.nonprofit.id
    end
    column "Nonprofit" do |role|
      role.nonprofit.name
    end
    column :title
    column :description
  end
end