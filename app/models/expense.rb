class Expense < ApplicationRecord
  monetize :amount_cents

  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :savings_plan, optional: true
  belongs_to :money_account

  has_many :expense_splits, dependent: :destroy
  has_many :expense_participants, through: :expense_splits, source: :user

  enum :expense_type, { personal: 0, shared: 1 }

  validates :description, presence: true
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :expense_date, presence: true

  # validate :splits_sum_to_100_percent, if: -> { shared? && expense? }

  # after_create :create_default_splits, if: -> { shared? && expense? }

  def total_splits_percentage
    expense_splits.sum(:percentage)
  end

  def amount_for_user(user)
    split = expense_splits.find_by(user: user)
    return 0 unless split
    (amount * split.percentage / 100.0).round(2)
  end

  def split_details
    expense_splits.includes(:user).map do |split|
      {
        user: split.user,
        percentage: split.percentage,
        amount: (amount * split.percentage / 100.0).round(2)
      }
    end
  end

  def expense?
    true
  end

  def incoming?
    false
  end

  private

  def splits_sum_to_100_percent
    return unless shared? && expense_splits.present?

    unless total_splits_percentage == 100
      errors.add(:base, "Los porcentajes deben sumar exactamente 100%")
    end
  end

  def create_default_splits
    # TODO: scope users to those who are part of the shared budget
    User.find_each do |user|
      expense_splits.create!(
        user: user,
        percentage: user.percentage.to_f || 50.0
      )
    end
  end
end