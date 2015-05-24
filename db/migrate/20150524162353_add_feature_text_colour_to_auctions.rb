class AddFeatureTextColourToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :feature_text_colour, :string
  end
end
