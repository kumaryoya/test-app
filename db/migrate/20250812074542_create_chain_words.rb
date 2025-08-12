class CreateChainWords < ActiveRecord::Migration[7.0]
  def change
    create_table :chain_words do |t|
      t.references :user, null: false, foreign_key: true
      t.string :word, null: false
      t.timestamps
    end
  end
end
