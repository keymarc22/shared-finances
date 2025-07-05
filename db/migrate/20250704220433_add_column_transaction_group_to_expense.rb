class AddColumnTransactionGroupToExpense < ActiveRecord::Migration[8.0]
  def change
    remove_column :transaction_groups, :transaction_id, :bigint
    add_reference :transactions, :transaction_group
    add_column :transaction_groups, :expenses_count, :integer, default: 0, null: false
  end
end
