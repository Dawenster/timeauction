class AddLimitBiddersToTiers < ActiveRecord::Migration
  def change
    add_column :tiers, :limit_bidders, :boolean
  end
end
