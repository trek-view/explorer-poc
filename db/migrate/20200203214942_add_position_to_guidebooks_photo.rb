class AddPositionToGuidebooksPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :guidebooks_photos, :position, :integer
  end
end
