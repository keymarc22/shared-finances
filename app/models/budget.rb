class Budget < ApplicationRecord
  monetize :amount_cents

  enum :budget_type, %i[personal shared]

  belongs_to :account

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  def is_over_budget?
    # spent_amount > amount
  end
end
