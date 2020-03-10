class AddMapillaryToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :mapillary, :hstore
  end
end
