class AddAuctionTypeToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :auction_type, :string, :default => "normal"
  end
end
