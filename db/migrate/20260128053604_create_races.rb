class CreateRaces < ActiveRecord::Migration[7.0]
  def change
    create_table :races do |t|
      t.date :date, null: false
      t.integer :stadium_id, null: false
      t.integer :race_number, null: false
      t.timestamps
    end

    add_index :races, [:date, :stadium_id, :race_number], unique: true, name: 'idx_races_on_date_stadium_number'
  end
end
