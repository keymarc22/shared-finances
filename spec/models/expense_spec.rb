require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category).optional }
    it { should belong_to(:paid_by).class_name("User") }
    it { should belong_to(:savings_plan).optional }
    it { should have_many(:expense_splits).dependent(:destroy) }
    it { should have_many(:expense_participants).through(:expense_splits).source(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:expense_type).with_values([:personal, :shared]) }
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }
    let(:expense) { create(:expense, user: user, category: category, amount_cents: 100) }

    describe '#total_splits_percentage' do
      it 'returns the sum of all expense splits percentages' do
        create(:expense_split, expense: expense, percentage: 30)
        create(:expense_split, expense: expense, percentage: 70)
        expect(expense.total_splits_percentage).to eq(100)
      end
    end

    describe '#amount_for_user' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      it 'returns the amount for a given user based on their split percentage' do
        create(:expense_split, expense: expense, user: user1, percentage: 40)
        expect(expense.amount_for_user(user1).cents).to eq(40.0)
      end

      it 'returns 0 if the user does not have a split' do
        expect(expense.amount_for_user(user2)).to eq(0)
      end
    end

    describe '#split_details' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      before do
        create(:expense_split, expense: expense, user: user1, percentage: 40)
        create(:expense_split, expense: expense, user: user2, percentage: 60)
      end

      it 'returns an array of hashes with user, percentage, and amount for each split' do
        details = expense.split_details
        expect(details.size).to eq(2)
        expect(details[0][:user]).to eq(user1)
        expect(details[0][:percentage]).to eq(40)
        expect(details[0][:amount].cents).to eq(40.0)
        expect(details[1][:user]).to eq(user2)
        expect(details[1][:percentage]).to eq(60)
        expect(details[1][:amount]).to eq(60.0)
      end
    end

    describe '#expense?' do
      it 'returns true' do
        expect(expense.expense?).to be true
      end
    end

    describe '#incoming?' do
      it 'returns false' do
        expect(expense.incoming?).to be false
      end
    end
  end

  xcontext 'when shared expense' do
    let(:user) { create(:user, percentage: 10) }
    let(:expense) { create(:expense, user: user, expense_type: :shared, amount: 100) }

    describe 'validations' do
      it 'validates that splits sum to 100 percent' do
        expense = build(:expense, expense_type: :shared)
        expense.expense_splits.build(user: user, percentage: 40)
        expect(expense).to_not be_valid
        expense.expense_splits.build(user: user, percentage: 50)
        expect(expense).to be_valid
      end
    end

    describe 'callbacks' do
      it 'creates default splits after create' do
        expect {
          create(:expense, expense_type: :shared, amount_cents: 100, user: user)
        }.to change(ExpenseSplit, :count).by(User.count)
      end
    end
  end
end