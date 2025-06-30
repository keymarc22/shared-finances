class ExpensesController < ApplicationController
  def new
    @expense = Expense.new(user: current_user)
  end

  def create
    @expense = Expense.new(expense_params)
  end

  private
  def expense_params
    params.require(:expense).permit(
      :amount_cents,
      :description,
      :transaction_type,
      :category_id,
      :user_id,
      expense_splits_attributes: %i[user_id percentage]
    )
  end
end
