class AddLocationToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :location, :string
  end
end
