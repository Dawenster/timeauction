class RenameRewardsUsersToBids < ActiveRecord::Migration
  def change
    rename_table :rewards_users, :bids
  end
end
