class RemoveTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :budget_users

    remove_column :budgets, :period, :integer, default: 0, null: false
    remove_column :budgets, :status, :integer, default: 0, null: false
    remove_column :budgets, :start_date, :date
    remove_column :budgets, :end_date, :date
    remove_column :budgets, :category_id, :integer, default: 0, null: false
    remove_column :transactions, :category_id, :integer, default: 0, null: false

    create_table :accounts do |t|
      t.string :name, null: false
      t.timestamps
    end

    # Add account references without NOT NULL constraint first
    add_reference :users, :account, foreign_key: true
    add_reference :money_accounts, :account, foreign_key: true
    add_reference :transactions, :account, foreign_key: true
    add_reference :budgets, :account, foreign_key: true
    add_reference :savings_plans, :account, foreign_key: true
    add_reference :transaction_groups, :account, foreign_key: true

    add_reference :transactions, :budget, foreign_key: true

    # Create a default account and assign its id to existing records
    reversible do |dir|
      dir.up do
        account_id = execute("INSERT INTO accounts (name, created_at, updated_at) VALUES ('Default', NOW(), NOW()) RETURNING id").first['id']
        execute("UPDATE users SET account_id = #{account_id}")
        execute("UPDATE money_accounts SET account_id = #{account_id}")
        execute("UPDATE transactions SET account_id = #{account_id}")
        execute("UPDATE budgets SET account_id = #{account_id}")
        execute("UPDATE savings_plans SET account_id = #{account_id}")
        execute("UPDATE transaction_groups SET account_id = #{account_id}")
      end
    end

    # Now set NOT NULL constraint
    change_column_null :users, :account_id, false
    change_column_null :money_accounts, :account_id, false
    change_column_null :transactions, :account_id, false
    change_column_null :budgets, :account_id, false
    change_column_null :savings_plans, :account_id, false
    change_column_null :transaction_groups, :account_id, false

    add_index :users, [ :account_id, :email ], unique: true
  end
end
