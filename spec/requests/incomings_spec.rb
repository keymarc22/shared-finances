require 'rails_helper'

RSpec.describe "Incomings", type: :request, sign_in: true do
  let(:user)          { @user }
  let(:account)       { user.account }
  let(:money_account) { create(:money_account, name: "Efectivo", account: account, user: user) }
  let(:incoming)      { create(:incoming, money_account: money_account, user: user, account: account, transaction_date: Date.today, amount: 100) }

  it "GET /money_accounts/:money_account_id/incomings/new returns success" do
    get new_money_account_incoming_path(money_account)
    expect(response).to have_http_status(:ok)
  end

  it "POST /money_accounts/:money_account_id/incomings creates an incoming" do
    expect {
      post money_account_incomings_path(money_account), params: { incoming: {
        amount: 200,
        transaction_date: Date.today,
        money_account_id: money_account.id,
        description: 'new incoming'
      } }
    }.to change(Incoming, :count).by(1)
  end

  it "PATCH /incomings/:id updates an incoming" do
    patch incoming_path(incoming), params: { id: incoming.id, incoming: { amount: 300 }, money_account_id: money_account.id }
    # expect(incoming.reload.amount).to eq(300)
  end

  it "DELETE /incomings/:id destroys an incoming" do
    delete incoming_path(incoming)
    expect(Incoming.count).to eq 0
  end
end
