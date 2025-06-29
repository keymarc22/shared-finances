class AddCommentToExpense < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :comment, :text
    change_column_default :expenses, :expense_type, from: nil, to: 0
  end
end
