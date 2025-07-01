class Transaction < ApplicationRecord
  monetize :amount_cents

  enum :interval, {
    weekly: 1,
    monthly: 2,
    yearly: 3
  }

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :frequency, :interval, presence: true

  def expense?
    is_a?(Expense)
  end

  def incoming?
    is_a?(Incoming)
  end

end