class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.string :name
      t.integer :year
      t.datetime :as_date

      t.timestamps
    end
  end
end
