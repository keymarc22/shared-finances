class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :expenses, dependent: :destroy
  has_many :incomings, dependent: :destroy

  has_many :user_savings_plans, dependent: :destroy
  has_many :savings_plans, through: :user_savings_plans

  has_many :budget_users, dependent: :destroy
  has_many :budgets, through: :budget_users
  # has_many :notifications, dependent: :destroy

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # validate :total_percentage_must_be_100

  private

  def total_percentage_must_be_100
    total = User.sum(:percentage) + self.percentage.to_i

    if total > 100
      errors.add(:percentage, "La suma de los porcentajes de todos los usuarios debe ser 100 (actual: #{total})")
    end
  end
end
