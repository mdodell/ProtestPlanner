class CreateMapMarkers < ActiveRecord::Migration[6.0]
  def change
    create_table :map_markers do |t|
      t.string :message
      t.string :location
      t.integer :event_id
      t.string :type

      t.timestamps
    end
  end
end
