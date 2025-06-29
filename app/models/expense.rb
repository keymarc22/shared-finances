class Expense < Transaction

  enum :transaction_type, { personal: 0, shared: 1 }

  belongs_to :category, optional: true

  has_many :expense_splits, foreign_key: :expense_id, dependent: :destroy
  has_many :expense_participants, through: :expense_splits, source: :user

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