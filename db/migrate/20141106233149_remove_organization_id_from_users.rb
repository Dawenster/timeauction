class RemoveOrganizationIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :organization_id
  end
end
