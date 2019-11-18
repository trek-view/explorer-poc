class CreateGoogles < ActiveRecord::Migration[5.2]
  def change
    create_table :googles do |t|
      t.string :plus_code_global_code
      t.string :plus_code_compound_code

      t.timestamps
    end
  end
end
