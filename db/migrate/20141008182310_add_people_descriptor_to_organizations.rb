class AddPeopleDescriptorToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :people_descriptor, :string
  end
end
