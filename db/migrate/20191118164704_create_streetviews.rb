class CreateStreetviews < ActiveRecord::Migration[5.2]
  def change
    create_table :streetviews do |t|
      t.string :photo_id
      t.datetime :capture_time
      t.text :share_link
      t.text :download_url
      t.text :thumbnail_url
      t.decimal :lat
      t.decimal :lon
      t.integer :altitude
      t.integer :heading
      t.integer :pitch
      t.integer :roll
      t.integer :level
      t.text :connections, array: true, default: []

      t.timestamps
    end
  end
end
