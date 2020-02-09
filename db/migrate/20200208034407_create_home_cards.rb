class CreateHomeCards < ActiveRecord::Migration[5.2]
  def change
    create_table :home_cards do |t|
      t.string :name, limit: 20
      t.text :description

      t.timestamps
    end
  end
end
