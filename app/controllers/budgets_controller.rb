class BudgetsController < ApplicationController
  before_action :find_budget, only: %i[show update destroy]
  def index
    @budgets = current_account.budgets.order(created_at: :desc)
  end

  def create
    @budget = current_account.budgets.new(budget_params)
    @budget.user_id = current_user.id if @budget.personal?

    if @budget.save && @budget.valid?
      flash.now[:notice] = "Budget creado correctamente"
    else
      flash.now[:error] = "Error al crear el budget"
      # render :index, status: :unprocessable_entity
    end
  end

  def new
    @budget = current_account.budgets.new
  end

  def show; end

  def update
    if @budget.update(budget_params) && @budget.valid?
      flash.now[:notice] = "Budget actualizado correctamente"
    else
      flash.now[:error] = "Error al actualizar el budget"
    end
  end

  def destroy
    @budget.destroy
  end

  private

  def find_budget
    @budget = current_account.budgets.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:name, :amount, :budget_type)
  end
end
