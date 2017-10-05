class ReplaceAgeWithConsent < ActiveRecord::Migration[5.1]
  def change
    remove_column :research_sessions, :age, :string
  end
end
