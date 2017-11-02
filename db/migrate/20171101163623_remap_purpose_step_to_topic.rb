class RemapPurposeStepToTopic < ActiveRecord::Migration[5.1]
  def up
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET status = 'topic'
      WHERE status = 'purpose'
    PostgreSQL
  end

  def down
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET status = 'purpose'
      WHERE
        status = 'topic' AND
        topic <> '' AND
        purpose <> ''
    PostgreSQL
  end
end
