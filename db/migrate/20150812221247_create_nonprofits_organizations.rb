class CreateNonprofitsOrganizations < ActiveRecord::Migration
  def change
    create_table :nonprofits_organizations do |t|
      t.belongs_to :nonprofit
      t.belongs_to :organization

      t.timestamps
    end
  end
end
