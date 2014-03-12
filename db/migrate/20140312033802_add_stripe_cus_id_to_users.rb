class AddStripeCusIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_cus_id, :string
  end
end
