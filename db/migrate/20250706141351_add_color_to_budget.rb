class AddColorToBudget < ActiveRecord::Migration[8.0]
  def change
    add_column :budgets, :color, :string, default: '#000000', null: false
    add_column :budgets, :icon, :string, default: 'flame', null: false # to use with lucide icons
  end
end
