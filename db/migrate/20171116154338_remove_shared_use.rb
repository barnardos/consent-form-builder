class RemoveSharedUse < ActiveRecord::Migration[5.1]
  def change
    remove_column :research_sessions, :shared_use, :string
  end
end
