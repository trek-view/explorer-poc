class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :cafe
      t.string :road
      t.string :suburb
      t.string :county
      t.string :region
      t.string :state
      t.string :postcode
      t.string :country
      t.string :country_code

      t.timestamps
    end
  end
end
