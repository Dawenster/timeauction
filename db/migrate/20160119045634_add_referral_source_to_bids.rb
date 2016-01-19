class AddReferralSourceToBids < ActiveRecord::Migration
  def change
    add_column :bids, :referral_source, :string
  end
end
