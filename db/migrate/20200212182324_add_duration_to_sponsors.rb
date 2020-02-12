class AddDurationToSponsors < ActiveRecord::Migration[5.2]
  def change
    add_column :sponsors, :duration, :string
  end
end
