class CreateTourers < ActiveRecord::Migration[5.2]
  def change
    create_table :tourers do |t|
      t.string :photo_id
      t.string :connection_method
      t.string :connection_photo
      t.integer :connection_distance_meters
      t.float :heading

      t.timestamps
    end
  end
end
