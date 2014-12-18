class AddDefaultDraftToTrueOnOrganizations < ActiveRecord::Migration
  def change
    change_column :organizations, :draft, :boolean, :default => true
  end
end
