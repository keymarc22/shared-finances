require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'enums' do
    it 'defines the correct values for period' do
      expect(Budget.periods.keys).to match_array(%w[weekly monthly quarterly yearly])
    end

    it 'defines the correct values for budget_type' do
      expect(Budget.budget_types.keys).to match_array(%w[personal shared])
    end

    it 'defines the correct values for status' do
      expect(Budget.statuses.keys).to match_array(%w[active paused completed])
    end
  end

  describe 'associations' do
    it 'belongs to category' do
      category = Category.create!(name: 'Test')
      budget = Budget.new(category: category)
      expect(budget.category).to eq(category)
    end

    it 'has many budget_users and destroys them on delete' do
      budget = create(:budget, name: 'Test', amount_cents: 100, start_date: Date.today, end_date: Date.tomorrow, category: Category.create!(name: 'Test'))
      user = create(:user, email: 'test@example.com', password: 'password')
      budget_user = budget.budget_users.create!(user: user)
      expect(budget.budget_users).to include(budget_user)
      budget.destroy
      expect(BudgetUser.where(id: budget_user.id)).to be_empty
    end

    it 'has many users through budget_users' do
      budget = create(:budget, name: 'Test', amount_cents: 100, start_date: Date.today, end_date: Date.tomorrow, category: Category.create!(name: 'Test'))
      user = create(:user, email: 'test@example.com', password: 'password')
      budget.budget_users.create!(user: user)
      expect(budget.users).to include(user)
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

    it 'is invalid without a start_date' do
      budget = Budget.new(start_date: nil)
      budget.validate
      expect(budget.errors[:start_date]).to include("can't be blank")
    end

    it 'is invalid without an end_date' do
      budget = Budget.new(end_date: nil)
      budget.validate
      expect(budget.errors[:end_date]).to include("can't be blank")
    end

    context 'end_date_after_start_date' do
      it 'is valid when end_date is after start_date' do
        budget = Budget.new(start_date: Date.current, end_date: Date.tomorrow)
        budget.valid?
        expect(budget.errors[:end_date]).to be_empty
      end

      it 'is not valid when end_date is before start_date' do
        budget = Budget.new(start_date: Date.tomorrow, end_date: Date.current)
        budget.valid?
        expect(budget.errors[:end_date]).to include("debe ser posterior a la fecha de inicio")
      end

      it 'is not valid when end_date is equal to start_date' do
        budget = Budget.new(start_date: Date.current, end_date: Date.current)
        budget.valid?
        expect(budget.errors[:end_date]).to include("debe ser posterior a la fecha de inicio")
      end
    end
  end

  # El resto del archivo (scopes, instance methods) puede quedarse igual.
  # ...
end
