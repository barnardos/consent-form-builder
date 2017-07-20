class CreateResearchSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :research_sessions do |t|
      t.string :status, default: 'new'

      t.string :age
      t.string :participant_name
      t.string :guardian_name
      t.string :methodologies, array: true
      t.string :recording_methods, array: true
      t.text :focus
      t.string :researcher_name
      t.string :researcher_phone
      t.string :researcher_email
      t.string :researcher_other_name
      t.boolean :incentive, default: false
      t.string :payment_type
      t.decimal :incentive_value

      t.timestamps

      t.index :status
    end
  end
end
