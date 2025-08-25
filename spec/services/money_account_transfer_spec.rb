require 'rails_helper'

RSpec.describe MoneyAccountTransfer do
  let(:user) { create(:user) }
  let(:from_account) { create(:money_account, user: user, account_id: user.account_id) }
  let(:to_account) { create(:money_account, user: user, account_id: user.account_id) }

  it "transfers funds correctly between accounts" do
    create(:incoming, transaction_type: 'personal', money_account: from_account, user: user, amount_cents: 10000)
    current_balance = from_account.balance
    target_account_balance = to_account.balance
    described_class.create(
      user,
      description: "Test transfer",
      amount: 50,
      from_money_account_id: from_account.id,
      to_money_account_id: to_account.id
    )

    expect(from_account.reload.balance).to eq(current_balance - Money.new(5000))
    expect(to_account.reload.balance).to eq(target_account_balance + Money.new(5000))
  end

  it "raises error if there are insufficient funds" do
    expect {
      described_class.create(
        user,
        description: "Insufficient transfer",
        amount: 200,
        from_money_account_id: from_account.id,
        to_money_account_id: to_account.id
      )
    }.to raise_error(MoneyAccountTransfer::MoneyAccountTransferError)
  end
end
