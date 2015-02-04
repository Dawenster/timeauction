class AddPageMessageToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :page_message, :string
  end
end
