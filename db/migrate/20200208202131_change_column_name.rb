class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :home_cards, :name, :title
  end
end
