class ExpenseSplit < ApplicationRecord
  belongs_to :expense, optional: true # Optional to allow creation without an expense initially
  belongs_to :user

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :user_id, uniqueness: { scope: :expense_id }

  def amount
    if self[:amount].present?
      self[:amount].to_f.round(2)
    else
      (expense.amount * percentage / 100.0).round(2)
    end
  end

  def formatted_percentage
    "#{percentage}%"
  end
end
