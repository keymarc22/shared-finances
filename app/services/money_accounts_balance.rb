class MoneyAccountsBalance
  def initialize(account)
    @account = account
  end

  def id
    nil
  end

  def name
    "Balance total"
  end

  def balance
    @account.money_accounts_balance
  end
end
