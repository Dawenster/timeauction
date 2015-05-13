class AddWebinarAndDrawToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :webinar, :boolean
    add_column :rewards, :draw, :boolean
  end
end
