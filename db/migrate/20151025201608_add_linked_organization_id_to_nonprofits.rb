class AddLinkedOrganizationIdToNonprofits < ActiveRecord::Migration
  def change
    add_column :nonprofits, :linked_organization_id, :integer
  end
end
