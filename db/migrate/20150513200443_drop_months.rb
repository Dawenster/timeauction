class DropMonths < ActiveRecord::Migration
  def change
    drop_table :months
  end
end
