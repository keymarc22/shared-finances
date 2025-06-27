class ExpenseSplit < ApplicationRecord
  belongs_to :expense
  belongs_to :user

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :user_id, uniqueness: { scope: :expense_id }
  validates :pecentage, presence: true, unless: :amount
  validates :amount, presence: true, unless: :percentage

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
