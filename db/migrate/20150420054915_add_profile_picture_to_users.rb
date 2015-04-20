class AddProfilePictureToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :profile_picture
  end
end
