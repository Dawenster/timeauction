class CreateHoursEntriesMonths < ActiveRecord::Migration
  def change
    create_table :hours_entries_months do |t|
      t.belongs_to :hours_entry
      t.belongs_to :month

      t.timestamps
    end
  end
end
