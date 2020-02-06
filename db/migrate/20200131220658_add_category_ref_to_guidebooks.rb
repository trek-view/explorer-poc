class AddCategoryRefToGuidebooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :guidebooks, :category, foreign_key: true
  end
end
