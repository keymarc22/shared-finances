require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it 'belongs to category (optional)' do
      expense = Expense.new
      expect(expense).to respond_to(:category)
    end

    it 'belongs to user' do
      expense = Expense.new
      expect(expense).to respond_to(:user)
    end

    it 'has many expense_participants through expense_splits' do
      expense = create(:expense)
      user = create(:user)
      split = create(:expense_split, expense: expense, user: user)
      expect(expense.expense_participants).to include(user)
    end
  end

  describe 'enums' do
    it 'defines enum for transaction_type with values [:personal, :shared]' do
      expect(Expense.transaction_types.keys).to match_array(%w[personal shared])
    end
  end
end