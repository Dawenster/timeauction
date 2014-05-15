class AddApplicationAndMessageToBids < ActiveRecord::Migration
  def change
    add_column :bids, :application, :text
    add_column :bids, :message, :text
  end
end
