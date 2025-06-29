class DashboardController < ApplicationController

  def index
    @summary = DashboardSummaryService.new.call
    @recent_expenses = recent_expenses_data
    @savings_plans = []

    # @balance = balance_data
    # @current_budgets = current_budgets_data
    # @balance_summary = balance_summary_data
    # @detailed_breakdown = detailed_breakdown_data
    # @budget_summary = budget_summary_data
  end

  private

  def balance_data
    @balance_data ||= BalanceCalculatorService.new.calculate
  end

  def recent_expenses_data
    Expense.includes(:category, :user, :expense_splits).
      order(transaction_date: :desc, created_at: :desc).
      limit(10)
  end

  def savings_plans_data
    current_user.savings_plans
                .active
                .includes(:category, :user, :monthly_contributions, :savings_contributions)
                .order(:deadline)
  end

  def current_budgets_data
    BudgetMonitorService.new(current_user).current_budgets_status
  end

  def budget_summary_data
    BudgetMonitorService.new(current_user).budget_summary
  end
end