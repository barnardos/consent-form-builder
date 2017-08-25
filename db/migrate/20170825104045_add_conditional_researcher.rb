class AddConditionalResearcher < ActiveRecord::Migration[5.1]
  def change
    add_column :research_sessions, :researcher_other, :boolean
  end
end
