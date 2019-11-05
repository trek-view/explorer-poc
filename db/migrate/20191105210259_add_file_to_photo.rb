class AddFileToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :file_url, :string
    add_column :photos, :thumbnail_url, :string
  end
end
