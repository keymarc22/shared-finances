require 'rails_helper'

RSpec.describe "TransactionGroups", type: :request, sign_in: true do
  let(:user)    { @user }
  let(:account) { user.account }
  let(:group)   { create(:transaction_group, name: "Grupo", account: account) }

  it "GET /transaction_groups returns success" do
    get transaction_groups_path
    expect(response).to have_http_status(:ok)
  end

  it "POST /transaction_groups creates a group" do
    expect {
      post transaction_groups_path, params: { transaction_group: { name: "Nuevo", account_id: account.id } }
    }.to change(TransactionGroup, :count).by(1)
  end

  it "PATCH /transaction_groups/:id updates a group" do
    patch transaction_group_path(group), params: { transaction_group: { name: "Modificado" } }
    expect(group.reload.name).to eq("Modificado")
  end

  it "DELETE /transaction_groups/:id destroys a group" do
    tg = TransactionGroup.create!(name: "Eliminar", account: account)
    expect {
      delete transaction_group_path(tg)
    }.to change(TransactionGroup, :count).by(-1)
  end
end
