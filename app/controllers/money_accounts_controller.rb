class MoneyAccountsController < ApplicationController
  def index
    @money_accounts = MoneyAccount.all
    @transactions = transactions
  end

  private

  def transactions
    Transaction.includes(:category, :user).
      order(transaction_date: :desc, created_at: :desc)
  end
end
