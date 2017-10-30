class AddNameToResearchSession < ActiveRecord::Migration[5.1]
  def up
    add_column :research_sessions, :name, :string
    add_column :research_sessions, :slug, :string
    add_index :research_sessions, :slug, unique: true

    execute <<~PostgreSQL
      UPDATE research_sessions
      SET name = id, slug = id
    PostgreSQL
  end

  def down
    remove_column :research_sessions, :name
    remove_column :research_sessions, :slug
  end
end
