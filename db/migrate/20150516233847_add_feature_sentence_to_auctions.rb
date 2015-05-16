class AddFeatureSentenceToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :feature_sentence, :string
  end
end
