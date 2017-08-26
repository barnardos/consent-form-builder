class SessionTime < ActiveRecord::Migration[5.1]
  def change
    add_column :research_sessions, :start_datetime, :datetime
    add_column :research_sessions, :duration, :string
    add_column :research_sessions, :participant_equipment, :text
  end
end
