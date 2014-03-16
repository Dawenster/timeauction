class AddUserEnteredToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :user_entered, :boolean, :default => false
  end
end
