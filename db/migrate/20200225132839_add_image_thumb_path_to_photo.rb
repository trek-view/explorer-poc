class AddImageThumbPathToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :image_thumb_path, :string
  end
end
