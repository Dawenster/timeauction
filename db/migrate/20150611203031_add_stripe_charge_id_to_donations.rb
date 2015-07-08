class AddStripeChargeIdToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :stripe_charge_id, :string
  end
end
