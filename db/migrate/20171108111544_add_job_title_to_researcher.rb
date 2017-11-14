class AddJobTitleToResearcher < ActiveRecord::Migration[5.1]
  def change
    add_column :research_sessions, :researcher_job_title, :string
  end
end
