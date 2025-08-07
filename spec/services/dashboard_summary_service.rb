require 'rails_helper'

RSpec.describe DashboardSummaryService do
  let(:account) { create(:account) }
  let(:user1)   { create(:user, account: account, name: "Alice") }
  let(:user2)   { create(:user, account: account, name: "Bob") }
  let(:budget)  { create(:budget, account: account, amount: 10000) }
  let(:shared_budget) { create(:budget, account: account, amount: 5000, budget_type: 'shared') }

  before do
    # Personal expense for user1
    create(:expense, account: account, user: user1, transaction_date: Date.current, amount: 2000, transaction_type: :personal)
    # Shared expense for user2
    create(:expense, account: account, user: user2, transaction_date: Date.current, amount: 3000, transaction_type: :shared)
    # Fixed expense (should be excluded)
    create(:expense, account: account, user: user1, transaction_date: Date.current, amount: 1000, transaction_type: :personal, fixed: true)
    budget
    shared_budget
  end

  subject(:service) { described_class.new(account) }

  describe "#call" do
    let(:result) { service.call }

    it "calculates total_expenses for current month excluding fixed" do
      expect(result[:total_expenses].to_i).to eq(5000) # 2000 + 3000
    end

    it "calculates total_budgets" do
      expect(result[:total_budgets].to_i).to eq(15000) # 10000 + 5000
    end

    it "calculates total_expenses_percentage" do
      expect(result[:total_expenses_percentage]).to eq(33.3) # 5000 / 15000 * 100
    end

    it "returns shared_expenses only" do
      expect(result[:shared_expenses].pluck(:transaction_type)).to all(eq("shared"))
      expect(result[:shared_expenses].sum(&:amount)).to eq(Money.new(300000))
    end

    it "calculates total_shared_expenses" do
      expect(result[:total_shared_expenses].to_i).to eq(3000)
    end

    it "calculates total_shared_budgets" do
      expect(result[:total_shared_budgets].to_i).to eq(5000)
    end

    it "calculates shared_expenses_percentage" do
      expect(result[:shared_expenses_percentage]).to eq(60.0) # 3000 / 5000 * 100
    end

    it "returns users_summary with correct totals" do
      summary = result[:users_summary]
      alice = summary.find { |u| u[:name] == "Alice" }
      bob   = summary.find { |u| u[:name] == "Bob" }
      expect(alice[:total_expenses].to_i).to eq(2000)
      expect(bob[:total_expenses].to_i).to eq(3000)
    end
  end

  describe "#calculate_percentage" do
    it "returns 0 if total is zero" do
      expect(service.send(:calculate_percentage, 10, 0)).to eq(0)
    end

    it "returns correct percentage" do
      expect(service.send(:calculate_percentage, 25, 100)).to eq(25.0)
    end
  end
end
