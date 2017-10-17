class AddLocationToTimeEquipment < ActiveRecord::Migration[5.1]
  def change
    add_column :research_sessions, :location, :string
  end
end
