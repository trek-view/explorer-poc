class AddTourerConnectionPhotosToPhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :tourer_connection_photo
    add_column :photos, :tourer_connection_photos, :text, array: true, default: []
    add_index :photos, :tourer_connection_photos, using: 'gin'
  end
end
