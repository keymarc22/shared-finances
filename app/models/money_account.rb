class MoneyAccount < ApplicationRecord
  belongs_to :user
  has_many :incomings
  has_many :expenses

  validates :name, presence: true

  def balance
    incomings.sum(:amount) - expenses.sum(:amount)
  end

end
