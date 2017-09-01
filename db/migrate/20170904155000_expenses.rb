class Expenses < ActiveRecord::Migration[5.1]
  def change
    add_column :research_sessions, :travel_expenses_limit, :decimal
    add_column :research_sessions, :food_expenses_limit, :decimal
    add_column :research_sessions, :other_expenses_limit, :decimal
    add_column :research_sessions, :receipts_required, :boolean, default: true
    add_column :research_sessions, :food_provided, :text
  end
end
