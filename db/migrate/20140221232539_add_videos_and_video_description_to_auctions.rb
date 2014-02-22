class AddVideosAndVideoDescriptionToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :video_description, :text
    add_column :auctions, :videos, :text
  end
end
