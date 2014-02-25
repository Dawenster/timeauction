class AddPremiumToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :premium, :boolean, :default => false
  end
end
