class ChangeGuidebooksPhotosToScenes < ActiveRecord::Migration[5.2]
  def change
    rename_table :guidebooks_photos, :scenes
  end
end
