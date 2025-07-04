class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :money_accounts, dependent: :destroy
  has_many :savings_plans, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :transaction_groups, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :incomings, class_name: "Incoming"
  has_many :expenses, class_name: "Expense"

  def money_accounts_balance
    money_accounts.sum(&:balance)
  end
end