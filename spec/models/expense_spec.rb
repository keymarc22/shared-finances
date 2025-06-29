require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it 'belongs to category (optional)' do
      expense = Expense.new
      expect(expense).to respond_to(:category)
    end

    it 'belongs to paid_by (User)' do
      expense = Expense.new
      expect(expense).to respond_to(:paid_by)
    end

    it 'belongs to savings_plan (optional)' do
      expense = Expense.new
      expect(expense).to respond_to(:savings_plan)
    end

    it 'has many expense_splits (dependent destroy)' do
      expense = create(:expense)
      split = create(:expense_split, expense: expense)
      expect(expense.expense_splits).to include(split)
      expense.destroy
      expect(ExpenseSplit.where(id: split.id)).to be_empty
    end

    it 'has many expense_participants through expense_splits' do
      expense = create(:expense)
      user = create(:user)
      split = create(:expense_split, expense: expense, user: user)
      expect(expense.expense_participants).to include(user)
    end
  end

  describe 'enums' do
    it 'defines enum for expense_type with values [:personal, :shared]' do
      expect(Expense.expense_types.keys).to match_array(%w[personal shared])
    end
  end

  # ... el resto del archivo igual ...
