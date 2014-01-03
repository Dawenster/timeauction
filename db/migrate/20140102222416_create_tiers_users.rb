class CreateTiersUsers < ActiveRecord::Migration
  def change
    create_table :tiers_users do |t|
      t.belongs_to :tier
      t.belongs_to :user
    end
  end
end
