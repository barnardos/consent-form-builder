class UpdateRenamedSteps < ActiveRecord::Migration[5.1]
  def up
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET status = 'storing'
      WHERE status = 'data';
      UPDATE research_sessions
      SET status = 'where_when'
      WHERE status = 'time_equipment';
      UPDATE research_sessions
      SET status = 'incentives'
      WHERE status = 'incentive';
    PostgreSQL
  end

  def down
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET status = 'data'
      WHERE status = 'storing';
      UPDATE research_sessions
      SET status = 'time_equipment'
      WHERE status = 'where_when';
      UPDATE research_sessions
      SET status = 'incentive'
      WHERE status = 'incentives';
    PostgreSQL
  end
end
