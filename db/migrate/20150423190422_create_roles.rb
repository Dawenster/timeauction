class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :title
      t.text :description
      t.belongs_to :nonprofit
      t.belongs_to :user

      t.timestamps
    end
  end
end
