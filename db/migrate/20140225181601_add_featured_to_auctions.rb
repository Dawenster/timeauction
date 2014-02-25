class AddFeaturedToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :featured, :boolean, :default => false
  end
end
