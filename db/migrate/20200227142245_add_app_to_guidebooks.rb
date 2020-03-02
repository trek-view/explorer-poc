class AddAppToGuidebooks < ActiveRecord::Migration[5.2]
  def change
    add_column :guidebooks, :app, :boolean, default: false
  end
end
