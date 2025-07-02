class Budget < ApplicationRecord
  monetize :amount_cents

  enum :budget_type, %i[personal shared]

  belongs_to :account
  belongs_to :user, optional: true

  has_many :expenses, dependent: :destroy

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true, if: :personal?

  def is_over_budget?
    # spent_amount > amount
  end

  def total_expenses
    @total_expenses ||= expenses.sum(:amount_cents)
  end

  def percentage
    return 0 if amount.zero?

    (total_expenses.to_f / amount.to_f * 100).round(2)
  end
end
