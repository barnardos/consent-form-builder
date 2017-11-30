class RemapMethodologiesKeys < ActiveRecord::Migration[5.1]
  def up
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET methodologies = array_replace(methodologies, 'observation', 'usability')
      WHERE NOT ('usability' = ANY (methodologies));

      UPDATE research_sessions
      SET methodologies = array_remove(methodologies, 'observation')
      WHERE 'usability' = ANY (methodologies);
    PostgreSQL
  end

  def down
    # we can't come back from the 'up'. Sorry.
  end
end
