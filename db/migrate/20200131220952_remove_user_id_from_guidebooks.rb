class RemoveUserIdFromGuidebooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :guidebooks, :user_id, :integer
  end
end
