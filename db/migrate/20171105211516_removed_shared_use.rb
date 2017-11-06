class RemovedSharedUse < ActiveRecord::Migration[5.1]
  def up
    remove_column :research_sessions, :shared_use
  end

  def down
    add_column :research_sessions, :shared_use, :text
  end
end
