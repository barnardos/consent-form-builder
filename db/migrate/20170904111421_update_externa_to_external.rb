class UpdateExternaToExternal < ActiveRecord::Migration[5.1]
  def up
    execute(
      <<-PostgreSQL
        UPDATE research_sessions
        SET shared_with = 'external'
        WHERE shared_with = 'externa'
      PostgreSQL
    )
  end

  def down
    execute(
      <<-PostgreSQL
        UPDATE research_sessions
        SET shared_with = 'externa'
        WHERE shared_with = 'external'
      PostgreSQL
    )
  end
end
