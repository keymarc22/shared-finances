class Expense < Transaction

  enum :transaction_type, { personal: 0, shared: 1 }

  belongs_to :category, optional: true

  has_many :expense_splits, foreign_key: :expense_id, dependent: :destroy
  has_many :expense_participants, through: :expense_splits, source: :user

  accepts_nested_attributes_for :expense_splits, allow_destroy: true, reject_if: :all_blank

  validate :splits_sum_to_100_percent, if: :shared?

  def total_splits_percentage
    expense_splits.sum(&:percentage)
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
      errors.add(:percentage, "Los porcentajes deben sumar exactamente 100%")
    end
  end
end
