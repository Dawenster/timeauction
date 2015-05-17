class AddEnterDrawOnBids < ActiveRecord::Migration
  def change
    add_column :bids, :enter_draw, :boolean
  end
end
