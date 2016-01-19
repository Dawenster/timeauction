class AddCompletionTimeToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :completion_month, :integer
    add_column :hours_entries, :completion_year, :integer
  end
end
