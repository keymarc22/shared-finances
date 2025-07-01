class MoneyAccount < ApplicationRecord
  belongs_to :user

  has_many :incomings
  has_many :expenses

  validates :name, presence: true
  accepts_nested_attributes_for :incomings, allow_destroy: true

  def balance
    incomings.sum(:amount_cents) - expenses.sum(:amount_cents)
  end

end
