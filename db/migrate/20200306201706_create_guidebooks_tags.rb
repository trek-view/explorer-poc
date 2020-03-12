class CreateGuidebooksTags < ActiveRecord::Migration[5.2]
  def change
    create_table :guidebooks_tags do |t|
      t.references :guidebook, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
