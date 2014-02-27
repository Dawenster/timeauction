class AddUpgradeDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :upgrade_date, :datetime
  end
end
