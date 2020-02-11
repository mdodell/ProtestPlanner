class CreateMapMarkers < ActiveRecord::Migration[6.0]
  def change
    create_table :map_markers do |t|
      t.string :message
      t.float :location_lat
      t.float :location_long
      t.integer :event_id
      t.string :type

      t.timestamps
    end
  end
end
