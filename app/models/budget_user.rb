class BudgetUser < ApplicationRecord
  belongs_to :budget
  belongs_to :user

  validates :budget_id, uniqueness: { scope: :user_id, message: "Ya existe un presupuesto asignado a este usuario" }
  validates :user_id, presence: true
  validates :budget_id, presence: true

  def self.for_budget(budget)
    where(budget: budget)
  end

  def self.for_user(user)
    where(user: user)
  end
end

# == Schema Information
#
# Table name: budget_users
#
#  id         :bigint           not null, primary key
#  budget_id  :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
