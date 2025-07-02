require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'enums' do
    it 'defines the correct values for budget_type' do
      expect(Budget.budget_types.keys).to match_array(%w[personal shared])
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      budget = Budget.new(name: nil)
      budget.validate
      expect(budget.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an amount' do
      budget = Budget.new(amount: nil)
      budget.validate
      expect(budget.errors[:amount]).to include("must be greater than 0")
    end

    it 'is invalid if amount is not greater than 0' do
      budget = Budget.new(amount: 0)
      budget.validate
      expect(budget.errors[:amount]).to include("must be greater than 0")
    end

  end

end
