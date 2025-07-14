class DashboardController < ApplicationController

  def index
    @summary = DashboardSummaryService.new(current_account).call
    @recent_expenses = recent_expenses_data
    @savings_plans = []
    @budgets = current_account.budgets.includes(:user)

    params[:tab_content] ||= "tab_expenses"

    if params[:tab_content] == "tab_user" && params[:user_id].present?
      @user = User.find(params[:user_id])
      @user_expenses = @user.expenses.includes(:budget, :money_account, :expense_splits)
    end
  end 

  private

  def recent_expenses_data
    current_account
      .expenses
      .no_fixed
      .includes(:budget, :user, :expense_splits)
      .created_between(current_date_rage.first, current_date_rage.last)
      .order(transaction_date: :desc, created_at: :desc)
  end
end