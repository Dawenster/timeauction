class AddVerifiedToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :verified, :boolean, :default => false
  end
end
