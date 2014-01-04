class RenameTiersIdOnRewardsUsers < ActiveRecord::Migration
  def change
    rename_column :rewards_users, :tier_id, :reward_id
  end
end
