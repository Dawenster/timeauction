class AddRewardIdToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :reward_id, :integer
  end
end
