class DashboardSummaryService
  include ActionView::Helpers::NumberHelper

  def initialize(account)
    @account = account
    @current_month_start = Date.current.beginning_of_month
    @current_month_end = Date.current.end_of_month
  end

  def call
    total_expenses = account
      .expenses
      .no_fixed
      .where(transaction_date: current_month_start..current_month_end)
      .sum(&:amount)

    total_budgets = account
      .budgets
      .sum(&:amount)

    shared_expenses = shared_expenses(account.expenses)
    total_shared_expenses = to_money shared_expenses.sum(:amount_cents)
    total_shared_budgets = to_money account.budgets.shared.sum(:amount_cents)

    {
      total_expenses: total_expenses,
      total_budgets: total_budgets,
      total_expenses_percentage: calculate_percentage(total_expenses, total_budgets),
      shared_expenses: shared_expenses,
      total_shared_expenses: total_shared_expenses,
      total_shared_budgets: total_shared_budgets,
      shared_expenses_percentage: calculate_percentage(total_shared_expenses, total_shared_budgets),
      users_summary: users_summary
    }
  end

  private

  attr_reader :account, :current_month_start, :current_month_end

  def shared_expenses(scope)
    scope.shared.no_fixed.where(transaction_date: current_month_start..current_month_end)
  end

  def personal_expenses(scope)
    scope.personal.no_fixed.where(transaction_date: current_month_start..current_month_end)
  end

  def users_summary
    @users_summary ||= begin
      account.users.find_each.map do |user|
        personal_expenses = personal_expenses(user.expenses)
        shared_expenses = shared_expenses(user.expenses)

        {
          id: user.id,
          name: user.name,
          total_expenses: to_money(personal_expenses.sum(:amount_cents) + shared_expenses.sum(:amount_cents))
        }
      end
    end
  end

  def to_money(amount)
    Money.new(amount)
  end

  def calculate_percentage(part, total)
    return 0 if total.zero?

    (part.to_f / total.to_f * 100).round(1)
  end
end
