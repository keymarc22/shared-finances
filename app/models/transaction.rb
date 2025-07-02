class Transaction < ApplicationRecord
  monetize :amount_cents

  enum :interval, {
    weekly: 1,
    monthly: 2,
    yearly: 3
  }

  belongs_to :account

  scope :created_between, ->(start_date, end_date) {
    where(transaction_date: start_date..end_date)
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