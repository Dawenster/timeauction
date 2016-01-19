class AddNewApplicationFieldsToBids < ActiveRecord::Migration
  def change
    add_column :bids, :completion_month, :integer
    add_column :bids, :completion_year, :integer
    add_column :bids, :referral_source, :string
  end
end
