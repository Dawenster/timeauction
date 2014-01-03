class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.string :title
      t.text :description
      t.integer :amount
      t.integer :max
      t.integer :auction_id

      t.timestamps
    end
  end
end
