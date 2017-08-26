class DataProcessing < ActiveRecord::Migration[5.1]
  def change
    add_column :research_sessions, :shared_with, :string
    add_column :research_sessions, :shared_duration, :string
    add_column :research_sessions, :shared_use, :text
  end
end
