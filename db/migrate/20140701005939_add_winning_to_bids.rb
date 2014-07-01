class AddWinningToBids < ActiveRecord::Migration
  def change
    add_column :bids, :winning, :boolean, :default => false
  end
end
