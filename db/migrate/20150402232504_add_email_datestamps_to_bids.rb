class AddEmailDatestampsToBids < ActiveRecord::Migration
  def change
    add_column :bids, :confirmation_sent_at, :datetime
    add_column :bids, :waitlist_sent_at, :datetime
  end
end
