class IncomingsController < ApplicationController
  before_action :find_money_account, only: %i[new create]
  before_action :find_incoming, only: %i[update edit destroy]
  def new
    @incoming = @money_account.incomings.build(user: current_user, transaction_date: Date.current)
  end

  def edit; end

  def create
    @incoming = @money_account.incomings.create(incoming_params.merge(user: current_user))
    if @incoming.valid?
      flash.now[:notice] = "Incoming creado correctamente."
    else
      flash.now[:error] = @incoming.errors.full_messages.to_sentence
    end
  end

  def update
    @money_account = @incoming.money_account
    if @incoming.update(incoming_params) && @incoming.valid?
      flash.now[:notice] = "Incoming actualizado correctamente."
    else
      flash.now[:error] = @incoming.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @incoming.destroy
      flash.now[:notice] = "Incoming eliminado correctamente."
    else
      flash.now[:error] = @incoming.errors.full_messages.to_sentence
    end
  end


  private

  def incoming_params
    params.require(:incoming).permit(
      :amount,
      :description,
      :transaction_date,
      :money_account_id
    ).merge(account_id: current_account.id)
  end

  def find_money_account
    @money_account = MoneyAccount.find(params[:money_account_id])
  end

  def find_incoming
    @incoming = Incoming.find(params[:id])
  end
end
