class CreateRaceResults < ActiveRecord::Migration[7.0]
  def change
    create_table :race_results do |t|
      t.references :race, null: false, foreign_key: true
      t.integer "rank1_boat", null: false
      t.integer "rank2_boat", null: false
      t.integer "rank3_boat", null: false
      t.integer "rank4_boat", null: false
      t.integer "rank5_boat", null: false
      t.integer "rank6_boat", null: false
      t.integer "trifecta_payout", null: false
      t.integer "trio_payout", null: false
      t.integer "exacta_payout", null: false
      t.integer "quinella_payout", null: false
      t.timestamps
    end
  end
end
