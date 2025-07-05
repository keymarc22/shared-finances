class TransactionGroup < ApplicationRecord

  belongs_to :account

  has_many :expenses, class_name: "Expense", counter_cache: true
  validates :name, presence: true

  accepts_nested_attributes_for :expenses, allow_destroy: true

  def monthly_expenses
    expenses.sum(:amount_cents)
  end
end
