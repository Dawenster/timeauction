class AddSubmittedToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :submitted, :boolean, :default => false
  end
end
