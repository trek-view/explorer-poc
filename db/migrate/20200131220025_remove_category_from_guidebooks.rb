class RemoveCategoryFromGuidebooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :guidebooks, :category, :string
  end
end
