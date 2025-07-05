class TransactionGroupsController < ApplicationController
  before_action :find_transaction_group, only: %i[edit show update destroy add_expense]

  def index
    @transaction_groups = current_account.transaction_groups.order(created_at: :desc)
  end

  def new
    @transaction_group = current_account.transaction_groups.new
  end

  def create
    @transaction_group = current_account.transaction_groups.create(transaction_group_params)
    if @transaction_group.valid?
      flash.now[:notice] = "Cuenta creada correctamente."
    else
      flash.now[:error] = @transaction_group.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    @transaction_group.update(transaction_group_params)
    render json: { group: @transaction_group.as_json(include: { expenses: { methods: :amount_formatted } }) }, status: :ok
  end

  def add_expense
    expense_attrs = transaction_group_params[:expenses_attributes].first
    if expense_attrs[:id].present?
      @expense = @transaction_group.expenses.find(expense_attrs[:id])
      if @expense.update(expense_attrs)
        render json: { expense: @expense.as_json(methods: :amount_formatted) }, status: :ok
      else
        render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
      end
    else
      @expense = @transaction_group.expenses.build(expense_attrs)
      if @expense.save
        render json: { expense: @expense.as_json(methods: :amount_formatted) }, status: :ok
      else
        render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def show
    @budgets = current_account.budgets.order(created_at: :desc)
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @transaction_group.destroy
    flash.now[:notice] = "Grupo de gastos eliminado correctamente."
  end

  private

  def find_transaction_group
    @transaction_group = current_account.transaction_groups.find(params[:id])
  end

  def transaction_group_params
    params.require(:transaction_group).permit(
      :name,
      expenses_attributes: %i[
        id
        account_id
        amount_cents
        description
        budget_id
        frequency
        transaction_date
        fixed
        _destroy
      ]
    )
  end
end
