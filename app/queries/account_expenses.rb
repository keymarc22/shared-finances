module Queries
  class AccountExpenses
    def initialize(account, start_date: nil, end_date: nil, include_associations: true)
      @account = account
      @start_date = start_date
      @end_date = end_date
      @include_associations = include_associations
    end

    def call
      expenses = @account.expenses.no_fixed
      expenses = expenses.includes(:budget, :user, :expense_splits) if @include_associations
      expenses = expenses.where("transaction_date >= ?", @start_date) if @start_date.present?
      expenses = expenses.where("transaction_date <= ?", @end_date) if @end_date.present?
      expenses
    end
  end
end
