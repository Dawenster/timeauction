class RenameTiers < ActiveRecord::Migration
  def change
    rename_table :tiers, :rewards
  end
end
