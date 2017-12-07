class UpdateRecordingMethods < ActiveRecord::Migration[5.1]
  def up
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET recording_methods = array_replace(recording_methods, 'audio', 'voice')
    PostgreSQL
  end

  def down
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET recording_methods = array_replace(recording_methods, 'voice', 'audio')
    PostgreSQL
  end
end
