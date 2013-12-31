class AddFacebookImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_image, :string
  end
end
