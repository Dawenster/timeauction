class AddTimestampsToBids < ActiveRecord::Migration
  def change
    add_column :bids, :created_at, :datetime
    add_column :bids, :updated_at, :datetime
  end
end
