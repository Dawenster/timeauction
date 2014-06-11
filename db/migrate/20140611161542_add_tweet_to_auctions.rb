class AddTweetToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :tweet, :text
  end
end
