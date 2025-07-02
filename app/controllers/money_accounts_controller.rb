class MoneyAccountsController < ApplicationController
  before_action :find_money_account, only: %i[show update destroy]

  def index
    @money_accounts = MoneyAccount.all
    @transactions = transactions
  end

  def new
    @money_account = MoneyAccount.new
  end

  def create
    @money_account = MoneyAccount.create(money_account_params.merge(user: current_user))
    if @money_account.valid?
      flash.now[:notice] = "Cuenta creada correctamente."
    else
      flash.now[:error] = @money_account.errors.full_messages.to_sentence
    end
  end

  def show; end

  def update
    if @money_account.update(money_account_params) && @money_account.valid?
      flash.now[:notice] = "Cuenta actualizada correctamente."
    else
      flash.now[:error] = @money_account.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @money_account.destroy
      flash.now[:notice] = "Cuenta eliminada correctamente."
    else
      flash.now[:error] = @money_account.errors.full_messages.to_sentence
    end
  end

  private

  def money_account_params
    params.require(:money_account).permit(
      :name,
      incomings_attributes: %i[amount description _destroy user_id transaction_date]
    ).merge(account_id: current_account.id)
  end

  def find_money_account
    @money_account = MoneyAccount.find(params[:id])
  end

  def transactions
    current_account.transactions.includes(:user).
      order(transaction_date: :desc, created_at: :desc)
  end
end
