class AddEnableFieldsForOptionalSteps < ActiveRecord::Migration[5.1]
  def up
    add_column :research_sessions, :where_when_enabled, :boolean, default: false
    add_column :research_sessions, :expenses_enabled, :boolean, default: false
    rename_column :research_sessions, :incentive, :incentives_enabled

    ##
    # Detect what we ought to enable and enable it
    #
    execute <<~PostgreSQL
      UPDATE research_sessions
      SET where_when_enabled = (
        when_text <> '' OR
        duration <> '' OR
        location <> '' OR
        participant_equipment <> '' OR
        food_provided <> ''
      )
    PostgreSQL

    execute <<~PostgreSQL
      UPDATE research_sessions
      SET expenses_enabled = (
        travel_expenses_limit IS NOT NULL OR
        food_expenses_limit IS NOT NULL OR
        other_expenses_limit IS NOT NULL
      )
    PostgreSQL
  end

  def down
    remove_column :research_sessions, :where_when_enabled
    remove_column :research_sessions, :expenses_enabled
    rename_column :research_sessions, :incentives_enabled, :incentive
  end
end
