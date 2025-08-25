class AddColumnTransfererMoneyAccountToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions, :transferer_money_account, foreign_key: { to_table: :money_accounts }, index: true
  end
end
