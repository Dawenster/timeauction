class AddNameAndPositionToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :name, :string
    add_column :auctions, :position, :string
  end
end
