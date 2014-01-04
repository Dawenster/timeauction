class RenameTiersUsers < ActiveRecord::Migration
  def change
    rename_table :tiers_users, :rewards_users
  end
end
