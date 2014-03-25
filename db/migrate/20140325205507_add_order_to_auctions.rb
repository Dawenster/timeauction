class AddOrderToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :order, :integer
  end
end
