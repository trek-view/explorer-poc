class AddUrlToHomeCards < ActiveRecord::Migration[5.2]
  def change
    add_column :home_cards, :url, :string
  end
end
