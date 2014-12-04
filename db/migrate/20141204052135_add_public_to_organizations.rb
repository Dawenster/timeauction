class AddPublicToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :public, :boolean, :default => false
  end
end
