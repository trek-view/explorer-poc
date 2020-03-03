class CreateScenes < ActiveRecord::Migration[5.2]
  def change
    create_table :scenes do |t|
      t.references :photo, type: :uuid, foreign_key: true
      t.references :guidebook, foreign_key: true
      t.timestamps
    end

    add_column :scenes, :description, :string
    add_column :scenes, :position, :integer
  end
end
