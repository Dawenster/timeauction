ActiveAdmin.register Role do
  permit_params(
    :title,
    :description,
    :created_at,
    :updated_at
  )
end