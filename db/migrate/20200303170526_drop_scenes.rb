class DropScenes < ActiveRecord::Migration[5.2]
  def change
    drop_table :scenes
  end
end
