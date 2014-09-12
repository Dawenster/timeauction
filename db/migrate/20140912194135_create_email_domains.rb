class CreateEmailDomains < ActiveRecord::Migration
  def change
    create_table :email_domains do |t|
      t.string :domain
      t.integer :company_id

      t.timestamps
    end
  end
end
