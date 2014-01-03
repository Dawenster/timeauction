class AddBannerAndImageToAuctions < ActiveRecord::Migration
  def change
    add_attachment :auctions, :banner
    add_attachment :auctions, :image
  end
end
