class SavingsPlan < ApplicationRecord
  monetize :target_amount_cents

  belongs_to :account
  belongs_to :money_account

  has_many :user_savings_plans, dependent: :destroy
  has_many :users, through: :user_savings_plans
  has_many :incomings, dependent: :destroy
  has_many :expenses, dependent: :destroy

  validates :name, presence: true
  validates :target_amount, presence: true, numericality: { greater_than: 0 }
  validates :deadline, presence: true

  enum :plan_type, { shared: 0, personal: 1 }
  enum :status, {
    active: 0,
    completed: 1,
    paused: 2,
    cancelled: 3
  }

  def days_remaining
    return Money.new(0) if deadline < Date.current

    (deadline - Date.current).to_i
  end

  def monthly_target
    return Money.new(0) if days_remaining <= 0

    remaining_amount = target_amount - current_amount
    months_left = (days_remaining / 30.0).ceil
    (remaining_amount / months_left).round(2)
  end

  def current_amount
    amount = incomings.sum(:amount) - expenses.sum(:amount)
    Money.new(amount)
  end
end

# == Schema Information
# Table name: savings_plans
#
#  id                :bigint           not null, primary key
#  name              :string           not null
#  target_amount_cents :integer        not null
#  deadline          :date             not null
#  plan_type         :integer          default("shared"), not null
#  status            :integer          default("active"), not null
#  money_account_id  :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_savings_plans_on_money_account_id  (money_account_id)
