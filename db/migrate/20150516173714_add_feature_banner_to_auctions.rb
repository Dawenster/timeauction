class AddFeatureBannerToAuctions < ActiveRecord::Migration
  def change
    add_attachment :auctions, :feature_banner
  end
end
