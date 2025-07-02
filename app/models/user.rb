class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account

  has_many :expenses, dependent: :destroy
  has_many :incomings, dependent: :destroy

  has_many :user_savings_plans, dependent: :destroy
  has_many :savings_plans, through: :user_savings_plans

  # has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: { scope: :account_id }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es un correo electrónico válido" }
  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # validate :total_percentage_must_be_100

  private

  def total_percentage_must_be_100
    total = account.users.sum(:percentage) + self.percentage.to_i

    if total > 100
      errors.add(:percentage, "La suma de los porcentajes de todos los usuarios debe ser 100 (actual: #{total})")
    end
  end
end
