class AddTitleToScenes < ActiveRecord::Migration[5.2]
  def change
    add_column :scenes, :title, :string, limit: 100
  end
end
