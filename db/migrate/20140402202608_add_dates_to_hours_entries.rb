class AddDatesToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :dates, :string
  end
end
