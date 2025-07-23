module DashboardHelper
  def expenses_title
    case params[:filter]
    when "recent"
      "Gastos recientes"
    when /\Aby_user:(\d+)\z/
      "Mis gastos"
    when /\Aby_budget:(\d+)\z/
      "Gastos por budget"
    when /\Aby_money_account:(\d+)\z/
      "Gastos por cuenta"
    end
  end

  def expenses_subtitle
    case params[:filter]
    when "recent"
      "Últimos movimientos de gastos compartidos y personales"
    when /\Aby_user:(\d+)\z/
      "Registros de pago realizados por mi"
    when /\Aby_budget:(\d+)\z/
      "Gastos relactionados a #{current_account.budgets.find($1).name}"
    when /\Aby_money_account:(\d+)\z/
      "Gastos asociados a la cuenta #{current_account.money_accounts.find($1).name}"
    end
  end
end
