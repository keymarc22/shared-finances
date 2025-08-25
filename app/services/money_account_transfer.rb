class MoneyAccountTransfer
  class MoneyAccountTransferError < StandardError; end

  def self.create(user, description:, amount:, from_money_account_id:, to_money_account_id:)
    new(user, description, amount, from_money_account_id, to_money_account_id).send(:create!)
  end

  def self.update(user, transfer_id:, description:, amount:, from_money_account_id:, to_money_account_id:)
    new(user, description, amount, from_money_account_id, to_money_account_id, transfer_id).send(:update!)
  end

  def self.destroy(user, transfer_id:)
    new(user, transfer_id:).send(:destroy!)
  end

  private

  attr_reader :amount, :transfer, :from_money_account_id, :to_money_account_id, :user, :description

  def initialize(user, description, amount, from_money_account_id, to_money_account_id, transfer_id = nil)
    raise "Invalid data for transfer action" if user.nil? || amount.nil? || from_money_account_id.nil? || to_money_account_id.nil?

    @user = user
    @description = description
    @amount = amount
    @from_money_account_id = from_money_account_id
    @to_money_account_id = to_money_account_id

    @transfer = Transfer.find(transfer_id) if transfer_id
  end

  def create!
    from_account = MoneyAccount.find(from_money_account_id)
    to_account = MoneyAccount.find(to_money_account_id)

    if from_account.account_id != to_account.account_id
      raise "Las cuentas de origen y destino no pertenecen al mismo usuario"
    end

    if from_account.balance < Money.new(amount)
      raise "Fondos insuficientes en la cuenta de origen"
    end

    Transfer.create!(
      user:,
      description:,
      amount:,
      money_account_id: from_money_account_id,
      transferer_money_account_id: to_money_account_id
    )
  rescue => e
    Rails.logger.error("Failed to create money account transfer: #{e.message}")
    raise MoneyAccountTransferError, e.message
  end

  def update!
    raise "Transfer not found" if @transfer.nil?

    @transfer.update!(
      user:,
      description:,
      amount:,
      money_account_id: from_money_account_id,
      transferer_money_account_id: to_money_account_id
    )

    @transfer.reload
  rescue => e
    Rails.logger.error("Failed to update money account transfer: #{e.message}")
    raise MoneyAccountTransferError, e.message
  end

  def destroy!
    raise "Transfer not found" if @transfer.nil?

    @transfer.destroy!
    @transfer
  rescue => e
    Rails.logger.error("Failed to destroy money account transfer: #{e.message}")
    raise MoneyAccountTransferError, e.message
  end
end
