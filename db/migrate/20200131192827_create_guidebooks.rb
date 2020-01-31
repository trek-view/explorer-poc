class CreateGuidebooks < ActiveRecord::Migration[5.2]
  def change
    create_table :guidebooks do |t|
      t.string :name, limit: 70
      t.string :description, limit: 250
      t.string :category
      t.integer :user_id

      t.timestamps
    end
    add_index :guidebooks, :user_id
  end
end
