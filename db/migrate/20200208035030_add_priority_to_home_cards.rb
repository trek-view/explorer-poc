class AddPriorityToHomeCards < ActiveRecord::Migration[5.2]
  def change
    add_column :home_cards, :priority, :integer
  end
end
