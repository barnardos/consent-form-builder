class AddOtherMethodologyAndOtherRecordingMethod < ActiveRecord::Migration[5.1]
  def change
    add_column :research_sessions, :other_methodology, :string
    add_column :research_sessions, :other_recording_method, :string
  end
end
