class DashboardController < ApplicationController
  before_action :find_expenses

  def index
    @summary = DashboardSummaryService.new(current_account).call
    @savings_plans = []
    @budgets = current_account.budgets.includes(:user)
    @money_accounts = current_account.money_accounts
  end

  private

  def find_expenses
    params[:filter] ||= "recent"

    scope = current_account
      .expenses
      .no_fixed
      .includes(:budget, :user, :expense_splits)
      .created_between(current_date_rage.first, current_date_rage.last)

    @expenses = case params[:filter]
    when "recent"
      scope
    when /\Aby_user:(\d+)\z/
      scope.where(user_id: $1)
    when /\Aby_budget:(\d+)\z/
      scope.where(budget_id: $1)
    when /\Aby_money_account:(\d+)\z/
      scope.where(money_account_id: $1)
    end.order(transaction_date: :desc, created_at: :desc)
  end
end
