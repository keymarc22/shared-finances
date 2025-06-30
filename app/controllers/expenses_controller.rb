class ExpensesController < ApplicationController
  before_action :find_expense, only: %i[edit update destroy]

  def new
    @expense = Expense.new(user: current_user, transaction_date: Date.current)
  end

  def create
    @expense = Expense.create(expense_params)

    if @expense.valid?
      flash.now[:notice] = "Gasto creado correctamente."
      @summary = DashboardSummaryService.new.call
    else
      flash.now[:error] = @expense.errors.full_messages.to_sentence
    end
  end

  def update
    if @expense.update(expense_params) && @expense.valid?
      flash.now[:notice] = "Gasto actualizado correctamente."
      if @expense.valid?
        @summary = DashboardSummaryService.new.call
      end
    else
      flash.now[:error] = @expense.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @expense.destroy
      flash.now[:notice] = "Gasto eliminado correctamente."
      @summary = DashboardSummaryService.new.call
    else
      flash.now[:error] = @expense.errors.full_messages.to_sentence
    end
  end

  def expense_splits_fields
    @expense = params[:id].present? ? Expense.find(params[:id]) : Expense.new

    if @expense.expense_splits.empty?
      User.find_each do |user|
        @expense.expense_splits.build(user: user, percentage: user.percentage || 50)
      end
    end

    render partial: "/expenses/expense_splits_fields", locals: { expense: @expense }
  end

  private

  def expense_params
    params.require(:expense).permit(
      :amount_cents,
      :description,
      :transaction_type,
      :transaction_date,
      :category_id,
      :user_id,
      :money_account_id,
      :comment,
      expense_splits_attributes: %i[user_id percentage expense_id id _destroy]
    )
  end

  def find_expense
    @expense = Expense.find(params[:id])
  end
end
