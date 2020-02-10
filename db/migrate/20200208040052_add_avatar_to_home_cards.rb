class AddAvatarToHomeCards < ActiveRecord::Migration[5.2]
  def change
    add_column :home_cards, :avatar, :string
  end
end
