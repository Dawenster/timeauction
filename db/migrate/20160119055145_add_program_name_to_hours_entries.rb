class AddProgramNameToHoursEntries < ActiveRecord::Migration
  def change
    add_column :hours_entries, :program_name, :string
  end
end
