class AddDraftToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :draft, :boolean
  end
end
