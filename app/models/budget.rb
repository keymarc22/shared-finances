class Budget < ApplicationRecord
  monetize :amount_cents

  enum :budget_type, %i[personal shared]

  belongs_to :account

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  def spent_amount
    @spent_amount ||= calculate_spent_amount
  end

  def remaining_amount
    amount - spent_amount
  end

  def percentage_used
    return 0 if amount.zero?
    [(spent_amount / amount * 100).round(2), 100].min
  end

  def is_over_budget?
    spent_amount > amount
  end

  def is_near_limit?(threshold = 80)
    percentage_used >= threshold
  end

  def days_remaining
    return 0 if end_date < Date.current
    (end_date - Date.current).to_i
  end

  def daily_remaining_budget
    return 0 if days_remaining <= 0
    remaining_amount / days_remaining
  end

  private

  def calculate_spent_amount
    expenses = if shared?
      user_ids = budget_users.pluck(:user_id)
      Expense.where(user_id: user_ids, category: category, transaction_date: start_date..end_date)
    else
      user.expenses.where(category: category, transaction_date: start_date..end_date)
    end

    if shared?
      expenses.sum do |expense|
        if expense.shared?
          expense.expense_splits.sum { |split| expense.amount * split.percentage / 100.0 }
        else
          expense.amount
        end
      end
    else
      expenses.sum(:amount)
    end
  end

  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, "debe ser posterior a la fecha de inicio") if end_date <= start_date
  end
end
