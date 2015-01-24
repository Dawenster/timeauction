class AddDataPrivacyToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :data_privacy, :boolean
  end
end
