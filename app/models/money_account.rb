class MoneyAccount < ApplicationRecord
  belongs_to :user
  has_many :incomings
  has_many :expenses

  validates :name, presence: true

  def balance
    incomings.sum(:amount_cents) - expenses.sum(:amount_cents)
  end

end
