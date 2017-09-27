class Researchers < ActiveRecord::Migration[5.1]
  def change
    remove_column :research_sessions, :researcher_name, :string
    remove_column :research_sessions, :researcher_phone, :string
    remove_column :research_sessions, :researcher_email, :string
    remove_column :research_sessions, :researcher_other, :boolean
    remove_column :research_sessions, :researcher_other_name, :string

    create_table :researchers do |t|
      t.string :researcher_name
      t.string :researcher_phone
      t.string :researcher_email
      t.belongs_to :research_session, index: true
    end
  end
end
