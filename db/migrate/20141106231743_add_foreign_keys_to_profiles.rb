class AddForeignKeysToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :organization_id, :integer
    add_column :profiles, :user_id, :integer
  end
end
