class AddDemographicsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :occupation, :string
    add_column :users, :school, :string
    add_column :users, :school_year, :string
    add_column :users, :major, :string
    add_column :users, :referral_source, :string
  end
end
