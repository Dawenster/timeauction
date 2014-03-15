class RenameRewardIdToBidIdOnHoursEntries < ActiveRecord::Migration
  def change
    rename_column :hours_entries, :reward_id, :bid_id
  end
end
