class AddTransactionGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :transaction_groups do |t|
      t.string :name, null: false
      t.references :transaction

      t.timestamps
    end

    add_column :transactions, :frequency, :integer, default: 1, null: false
    add_column :transactions, :interval, :integer, default: 1, null: false # enum values: { weekly: 1, monthly: 2, yearly: 3 }

    change_column_null :transactions, :user_id, true
    change_column_null :transactions, :money_account_id, true
    change_column_null :transactions, :transaction_date, true
  end
end
