class AddUserRefToGuidebooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :guidebooks, :user, foreign_key: true
  end
end
