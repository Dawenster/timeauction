class AddPremiumToBids < ActiveRecord::Migration
  def change
    add_column :bids, :premium, :boolean, :default => false
  end
end
