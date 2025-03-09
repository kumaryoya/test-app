class AddSpreadsheetIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :spreadsheet_id, :string
  end
end
