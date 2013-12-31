class AddTimezoneAndGenderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :integer
    add_column :users, :gender, :string
  end
end
