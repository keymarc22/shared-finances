class AddInitialModels < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name,               null: false
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at
      t.integer :percentage

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :name,                 unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true

    create_table :expenses do |t|
      t.string :description, null: false
      t.integer :expense_type, null: false
      t.boolean :fixed, null: false, default: false
      t.date :expense_date, null: false
      t.references :money_account, null: false, foreign_key: true
      t.references :category
      t.references :user, null: false, foreign_key: true
      t.string :type, null: false, default: "Expense"
      t.references :savings_plan

      t.timestamps
    end

    add_monetize :expenses, :amount, null: false

    create_table :expense_splits do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.monetize :amount
      t.integer :percentage

      t.timestamps
    end

    create_table :money_accounts do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :savings_plans do |t|
      t.string :name, null: false
      t.monetize :target_amount, null: false
      t.references :money_account, null: false, foreign_key: true
      t.date :deadline, null: false
      t.integer :status, null: false, default: 0
      t.integer :plan_type, null: false, default: 0

      t.timestamps
    end

    create_table :user_savings_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :savings_plan

      t.timestamps
    end

    create_table :categories do |t|
      t.string :name, null: false
      t.integer :category_type, null: false, default: 0

      t.timestamps
    end

    create_table :budgets do |t|
      t.string :name, null: false
      t.integer :period, null: false, default: 0
      t.integer :budget_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.monetize :amount, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :category

      t.timestamps
    end

    create_table :budget_users do |t|
      t.references :budget, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

  end
end
