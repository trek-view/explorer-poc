class CreateSponsors < ActiveRecord::Migration[5.2]
  def change
    create_table :sponsors do |t|
      t.string :title, limit: 100
      t.text :description, limit: 250
      t.string :url

      t.timestamps
    end
  end
end
