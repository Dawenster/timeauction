class RenamePriceToTargetOnAuctions < ActiveRecord::Migration
  def change
    rename_column :auctions, :price, :target
  end
end
