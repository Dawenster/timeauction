class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :amount
      t.integer :tip
      t.integer :bid_id
      t.integer :nonprofit_id

      t.timestamps
    end
  end
end
