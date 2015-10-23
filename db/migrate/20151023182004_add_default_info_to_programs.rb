class AddDefaultInfoToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :default_name, :string
    add_column :programs, :default_position, :string
    add_column :programs, :default_email, :string
  end
end
