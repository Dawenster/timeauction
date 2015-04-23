class CreateNonprofitsUsers < ActiveRecord::Migration
  def change
    create_table :nonprofits_users do |t|
      t.belongs_to :nonprofit
      t.belongs_to :user

      t.timestamps
    end
  end
end
