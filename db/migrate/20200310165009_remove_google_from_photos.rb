class RemoveGoogleFromPhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :google, :hstore
  end
end
