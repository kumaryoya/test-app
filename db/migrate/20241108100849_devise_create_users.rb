# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :login_id, null: false
      t.string :encrypted_password, null: false
      t.timestamps null: false
    end

    add_index :users, :login_id, unique: true
  end
end
