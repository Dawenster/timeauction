class AddPointsToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :points, :integer
  end
end
