class CreateGuidebooksPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :guidebooks_photos do |t|
      t.references :photo, foreign_key: true
      t.references :guidebook, foreign_key: true

      t.timestamps
    end
  end
end
