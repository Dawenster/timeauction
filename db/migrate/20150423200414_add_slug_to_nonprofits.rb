class AddSlugToNonprofits < ActiveRecord::Migration
  def change
    add_column :nonprofits, :slug, :string
  end
end
