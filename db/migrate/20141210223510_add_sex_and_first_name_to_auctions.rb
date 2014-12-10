class AddSexAndFirstNameToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :sex, :string
    add_column :auctions, :first_name, :string
  end
end
