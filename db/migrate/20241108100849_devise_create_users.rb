# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :age, null: false
      t.string :login_id, null: false
      t.string :encrypted_password, null: false
      t.timestamps null: false
    end

    change_table :users, bulk: true do |t|
      t.index :email, unique: true
      t.index :login_id, unique: true
    end
  end
end
