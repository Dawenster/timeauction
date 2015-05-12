class AddHoursToMonths < ActiveRecord::Migration
  def change
    add_column :months, :hours, :integer
  end
end
