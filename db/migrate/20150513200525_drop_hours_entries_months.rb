class DropHoursEntriesMonths < ActiveRecord::Migration
  def change
    drop_table :hours_entries_months
  end
end
