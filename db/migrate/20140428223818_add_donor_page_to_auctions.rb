class AddDonorPageToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :on_donor_page, :boolean, :default => false
  end
end
