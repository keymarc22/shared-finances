require 'rails_helper'

RSpec.describe "MoneyAccounts", type: :request, sign_in: true do
  let(:user)    { @user }
  let(:account) { user.account }
  let(:money_account) { MoneyAccount.create!(name: "Efectivo", account: account, user: user) }

  it "GET /money_accounts returns success" do
    get money_accounts_path
    expect(response).to have_http_status(:ok)
  end

  it "POST /money_accounts creates a money account" do
    expect {
      post money_accounts_path, params: { money_account: { name: "Banco", account_id: account.id, user_id: user.id } }
    }.to change(MoneyAccount, :count).by(1)
  end

  it "PATCH /money_accounts/:id updates a money account" do
    patch money_account_path(money_account), params: { money_account: { name: "Tarjeta" } }
    expect(money_account.reload.name).to eq("Tarjeta")
  end

  it "DELETE /money_accounts/:id destroys a money account" do
    delete money_account_path(money_account)
   expect(MoneyAccount.count).to eq 0
  end
end