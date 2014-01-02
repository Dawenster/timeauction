class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :title
      t.boolean :approved
      t.text :description
      t.integer :price
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
