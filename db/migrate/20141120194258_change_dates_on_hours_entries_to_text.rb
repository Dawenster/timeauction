class ChangeDatesOnHoursEntriesToText < ActiveRecord::Migration
  def change
    change_column :hours_entries, :dates, :text
  end
end
