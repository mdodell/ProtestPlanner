class CreateMapMarkers < ActiveRecord::Migration[6.0]
  def change
    create_table :map_markers do |t|
      t.string :message
      t.float :latitude
      t.float :longitude
      t.integer :event_id
      t.integer :marker_type, default: 0

      t.timestamps
    end
  end
end
