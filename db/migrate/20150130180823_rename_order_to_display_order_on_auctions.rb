class RenameOrderToDisplayOrderOnAuctions < ActiveRecord::Migration
  def change
    rename_column :auctions, :order, :display_order
  end
end
