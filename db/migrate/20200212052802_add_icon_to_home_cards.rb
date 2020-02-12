class AddIconToHomeCards < ActiveRecord::Migration[5.2]
  def change
    add_column :home_cards, :icon, :string, limit: 15
  end
end
