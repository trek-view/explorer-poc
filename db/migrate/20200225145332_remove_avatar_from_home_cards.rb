class RemoveAvatarFromHomeCards < ActiveRecord::Migration[5.2]
  def change
    remove_column :home_cards, :avatar, :string
  end
end
