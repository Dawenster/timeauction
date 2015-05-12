class AddMonthAndYearToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :month, :integer
    add_column :hours_entries, :year, :integer
  end
end
