class AddDetailedDescriptionColumnsToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :short_description, :string
    add_column :auctions, :about, :text
    add_column :auctions, :limitations, :text
  end
end
