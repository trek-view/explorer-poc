class CreateScenesTags < ActiveRecord::Migration[5.2]
  def change
    create_table :scenes_tags do |t|
      t.references :scene, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
