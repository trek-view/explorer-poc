class ChangeIconLimiteToHomeCards < ActiveRecord::Migration[5.2]
  def change
    change_column :home_cards, :icon, :string, limit: 30
  end
end
