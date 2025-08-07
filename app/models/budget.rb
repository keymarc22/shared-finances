class Budget < ApplicationRecord
  monetize :amount_cents

  enum :budget_type, %i[personal shared]

  belongs_to :account
  belongs_to :user, optional: true

  has_many :expenses, dependent: :destroy

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true, if: :personal?

  ICONS = %w[
    flame
    alarm-clock
    armchair
    award
    badge-check
    banknote
    biceps-flexed
    bookmark
    boxes
    bubbles
    cake
    car
    coffee
    concierge-bell
    cookie
    dog
    flag
    gamepad-2
    github
    hand-coins
    heart
    house
    laugh
    lock-keyhole
    medal
    music
  ].freeze

  validates :icon, presence: true, inclusion: { in: ICONS }

  def total_expenses
    @total_expenses ||= expenses.no_fixed.sum(&:amount)
  end

  def percentage
    return 0 if amount.zero? || total_expenses.zero?

    (total_expenses.to_f / amount.to_f * 100).round(1)
  end
end
