class RenameImageUrlToPhoto < ActiveRecord::Migration[5.2]
  def change
    rename_column :photos, :image_url, :image_path
  end
end
