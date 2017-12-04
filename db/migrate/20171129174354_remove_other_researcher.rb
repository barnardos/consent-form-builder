class RemoveOtherResearcher < ActiveRecord::Migration[5.1]
  def change
    remove_column :research_sessions, :researcher_other, :boolean
    remove_column :research_sessions, :researcher_other_name, :string
  end
end
