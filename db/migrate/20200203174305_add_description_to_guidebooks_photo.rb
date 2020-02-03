class AddDescriptionToGuidebooksPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :guidebooks_photos, :description, :string
  end
end
