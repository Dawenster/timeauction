class AddNonprofitIdToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :nonprofit_id, :integer
  end
end
