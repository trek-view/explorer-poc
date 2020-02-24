class AddEnabledApikeyToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :enabled_apikey, :boolean, default: false
  end
end
