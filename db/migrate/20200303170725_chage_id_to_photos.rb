class ChageIdToPhotos < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'

    add_column :photos, :uuid, :uuid, default: 'uuid_generate_v4()', null: false

    change_table :photos do |t|
      t.remove :id
      t.rename :uuid, :id
    end
    execute "ALTER TABLE photos ADD PRIMARY KEY (id);"
  end
end
