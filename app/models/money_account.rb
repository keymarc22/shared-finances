class MoneyAccount < ApplicationRecord
  belongs_to :account
  belongs_to :user

  has_many :incomings
  has_many :expenses
  has_many :transfers # outgoing transfers
  has_many :transfered_incomings, class_name: "Transfer", foreign_key: "transferer_money_account_id" # incoming transfers

  validates :name, presence: true
  accepts_nested_attributes_for :incomings, allow_destroy: true

  def balance
    incomings_total - outgoings_total
  end

  def incomings_total
    incomings.sum(&:amount) + transfered_incomings.sum(&:amount)
  end

  def outgoings_total
    expenses.sum(&:amount) + transfers.sum(&:amount)
  end
end
