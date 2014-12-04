class AddPublicToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :can_show_publicly, :boolean, :default => false
  end
end
