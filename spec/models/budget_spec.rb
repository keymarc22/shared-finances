require 'rails_helper'

RSpec.describe Budget, type: :model do

  describe 'enums' do
    it { should define_enum_for(:period).with_values([:weekly, :monthly, :quarterly, :yearly]) }
    it { should define_enum_for(:budget_type).with_values([:personal, :shared]) }
    it { should define_enum_for(:status).with_values([:active, :paused, :completed]) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:budget_users).dependent(:destroy) }
    it { should have_many(:users).through(:budget_users) }
  end

  describe 'enums' do
    it { should define_enum_for(:period).with_values([:weekly, :monthly, :quarterly, :yearly]) }
    it { should define_enum_for(:budget_type).with_values([:personal, :shared]) }
    it { should define_enum_for(:status).with_values([:active, :paused, :completed]) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

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

  describe 'scopes' do
    describe '.current' do
      it 'returns budgets where start_date is before or equal to today and end_date is after or equal to today' do
        current_budget = Budget.create!(name: 'Current Budget', amount: 100, start_date: Date.current.beginning_of_month, end_date: Date.current.end_of_month)
        past_budget = Budget.create!(name: 'Past Budget', amount: 50, start_date: Date.current.last_year, end_date: Date.current.last_year.end_of_year)
        expect(Budget.current).to include(current_budget)
        expect(Budget.current).not_to include(past_budget)
      end
    end

    describe '.for_month' do
      it 'returns budgets where period is monthly and start_date is before or equal to the given date and end_date is after or equal to the given date' do
        monthly_budget = Budget.create!(name: 'Monthly Budget', amount: 100, start_date: Date.current.beginning_of_month, end_date: Date.current.end_of_month, period: :monthly)
        weekly_budget = Budget.create!(name: 'Weekly Budget', amount: 50, start_date: Date.current.beginning_of_week, end_date: Date.current.end_of_week, period: :weekly)
        expect(Budget.for_month(Date.current)).to include(monthly_budget)
        expect(Budget.for_month(Date.current)).not_to include(weekly_budget)
      end
    end
  end

  describe 'instance methods' do
    let(:category) { Category.create!(name: 'Test Category') }
    let(:user) { User.create!(email: 'test@example.com', password: 'password') }
    let(:budget) { Budget.new(name: 'Test Budget', amount: 100, start_date: Date.current.beginning_of_month, end_date: Date.current.end_of_month, category: category) }

    describe '#spent_amount' do
      it 'calls calculate_spent_amount and memoizes the result' do
        expect(budget).to receive(:calculate_spent_amount).once.and_return(50)
        expect(budget.spent_amount).to eq(50)
        expect(budget.spent_amount).to eq(50) # Ensure it's memoized
      end
    end

    describe '#remaining_amount' do
      it 'returns the difference between amount and spent_amount' do
        allow(budget).to receive(:spent_amount).and_return(30)
        expect(budget.remaining_amount).to eq(70)
      end
    end

    describe '#percentage_used' do
      it 'returns the percentage of the budget used' do
        allow(budget).to receive(:spent_amount).and_return(50)
        expect(budget.percentage_used).to eq(50.0)
      end

      it 'returns 100 when spent_amount is greater than amount' do
        allow(budget).to receive(:spent_amount).and_return(150)
        expect(budget.percentage_used).to eq(100)
      end

      it 'returns 0 when amount is zero' do
        budget.amount = 0
        expect(budget.percentage_used).to eq(0)
      end
    end

    describe '#is_over_budget?' do
      it 'returns true if spent_amount is greater than amount' do
        allow(budget).to receive(:spent_amount).and_return(120)
        expect(budget.is_over_budget?).to be true
      end

      it 'returns false if spent_amount is less than or equal to amount' do
        allow(budget).to receive(:spent_amount).and_return(80)
        expect(budget.is_over_budget?).to be false
      end
    end

    describe '#is_near_limit?' do
      it 'returns true if percentage_used is greater than or equal to the threshold' do
        allow(budget).to receive(:percentage_used).and_return(85)
        expect(budget.is_near_limit?).to be true
      end

      it 'returns false if percentage_used is less than the threshold' do
        allow(budget).to receive(:percentage_used).and_return(75)
        expect(budget.is_near_limit?).to be false
      end

      it 'uses a default threshold of 80' do
        allow(budget).to receive(:percentage_used).and_return(80)
        expect(budget.is_near_limit?).to be true
      end

      it 'accepts a custom threshold' do
        allow(budget).to receive(:percentage_used).and_return(70)
        expect(budget.is_near_limit?(70)).to be true
        expect(budget.is_near_limit?(80)).to be false
      end
    end

    describe '#days_remaining' do
      it 'returns the number of days remaining in the budget period' do
        budget.end_date = Date.current + 10.days
        expect(budget.days_remaining).to eq(10)
      end

      it 'returns 0 if the end_date is in the past' do
        budget.end_date = Date.current - 1.day
        expect(budget.days_remaining).to eq(0)
      end
    end

    describe '#daily_remaining_budget' do
      it 'returns the remaining budget per day' do
        allow(budget).to receive(:remaining_amount).and_return(50)
        allow(budget).to receive(:days_remaining).and_return(10)
        expect(budget.daily_remaining_budget).to eq(5)
      end

      it 'returns 0 if there are no days remaining' do
        allow(budget).to receive(:days_remaining).and_return(0)
        expect(budget.daily_remaining_budget).to eq(0)
      end
    end
  end

  describe '#calculate_spent_amount' do
    let(:category) { Category.create!(name: 'Food') }
    let(:user1) { create(:user, email: 'user1@example.com', password: 'password', percentage: 50) }
    let(:user2) { create(:user, email: 'user2@example.com', password: 'password', percentage: 50) }
    let(:start_date) { Date.current.beginning_of_month }
    let(:end_date) { Date.current.end_of_month }

    context 'when the budget is shared' do
      let(:budget) { Budget.create!(name: 'Shared Budget', amount: 200, start_date: start_date, end_date: end_date, category: category, budget_type: :shared) }

      before do
        BudgetUser.create!(budget: budget, user: user1)
        BudgetUser.create!(budget: budget, user: user2)
      end

      it 'calculates the spent amount correctly considering shared expenses and expense splits' do
        expense1 = create(:expense, user: user1, categor:y: category, amount: 50, expense_date: Date.current)
        expense2 = create(expense, user: user2, category: category, amount: 100, expense_date: Date.current, shared: true)
        ExpenseSplit.create!(expense: expense2, percentage: 50)

        expect(budget.calculate_spent_amount).to eq(100) # 50 (from expense1) + 50 (50% of 100 from expense2)
      end

      it 'includes only expenses within the budget date range' do
        create(:expense, user: user1, category: category, amount: 50, expense_date: start_date - 1.day) # Outside the range

        expect(budget.calculate_spent_amount).to eq(0)
      end

      it 'includes only expenses for the budget category' do
        other_category = Category.create!(name: 'Other Category')
        create(:expense, user: user1, category: other_category, amount: 50, expense_date: Date.current)

        expect(budget.calculate_spent_amount).to eq(0)
      end
    end

    context 'when the budget is personal' do
      let(:budget) { Budget.create!(name: 'Personal Budget', amount: 100, start_date: start_date, end_date: end_date, category: category, budget_type: :personal, users: [user1]) }

      it 'calculates the spent amount correctly for personal expenses' do
:        create(expense, user: user1, category: category, amount: 50, expense_date: Date.current)
        expect(budget.calculate_spent_amount).to eq(50)
      end

      it 'does not include expenses from other users' do
:        create(expense, user: user2, category: category, amount: 50, expense_date: Date.current)
        expect(budget.calculate_spent_amount).to eq(0)
      end
    end
  end
end