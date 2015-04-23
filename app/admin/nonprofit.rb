ActiveAdmin.register Nonprofit do
  permit_params(
    :name,
    :description,
    :slug,
    :created_at,
    :updated_at
  )
end
