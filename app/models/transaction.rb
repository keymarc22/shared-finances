class Transaction < ApplicationRecord
  monetize :amount_cents

  belongs_to :user
  belongs_to :money_account

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :transaction_date, presence: true

  # validate :splits_sum_to_100_percent, if: -> { shared? && expense? }

  # after_create :create_default_splits, if: -> { shared? && expense? }

  def expense?
    is_a?(Expense)
  end

  def incoming?
    is_a?(Incoming)
  end

end