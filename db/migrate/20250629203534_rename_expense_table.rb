class RenameExpenseTable < ActiveRecord::Migration[8.0]
  def change
    rename_table :expenses, :transactions
    rename_column :transactions, :expense_type, :transaction_type
    rename_column :transactions, :expense_date, :transaction_date
  end
end
