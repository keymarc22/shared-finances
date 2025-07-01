class TransactionGroup < ApplicationRecord

  has_many :expenses, class_name: "Expense", foreign_key: :transaction_id, dependent: :destroy
  validates :name, presence: true
end