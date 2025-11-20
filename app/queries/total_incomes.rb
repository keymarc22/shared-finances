module Queries
  class TotalIncomes
    def initialize(account, start_date: nil, end_date: nil)
      @account = account
      @start_date = start_date
      @end_date = end_date
    end

    def call
      incomes = @account.incomings
      incomes = incomes.where("transaction_date >= ?", @start_date) if @start_date.present?
      incomes = incomes.where("transaction_date <= ?", @end_date) if @end_date.present?
      incomes.sum(&:amount)
    end
  end
end
