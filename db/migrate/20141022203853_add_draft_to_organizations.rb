class AddDraftToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :draft, :boolean
  end
end
