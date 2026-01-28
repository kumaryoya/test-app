class CreateRaceEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :race_entries do |t|
      t.references :race, null: false, foreign_key: true
      t.integer :boat_number, null: false
      t.string :rank, null: false
      t.integer :flying_count, null: false
      t.integer :late_count, null: false
      t.float :average_st, null: false
      t.float :national_win_rate, null: false
      t.float :national_quinella_rate, null: false
      t.float :national_trio_rate, null: false
      t.float :local_win_rate, null: false
      t.float :local_quinella_rate, null: false
      t.float :local_trio_rate, null: false
      t.float :motor_quinella_rate, null: false
      t.float :motor_trio_rate, null: false
      t.timestamps
    end
  end
end
