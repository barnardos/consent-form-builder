class DefaultAge < ActiveRecord::Migration[5.1]
  def change
    change_column :research_sessions, :age, :string, default: 'over18'
  end
end
