class RenameCompanyId < ActiveRecord::Migration
  def change
    rename_column :users, :company_id, :organization_id
    rename_column :email_domains, :company_id, :organization_id
    rename_column :programs, :company_id, :organization_id
  end
end
