class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :tag_id
      t.date :date_from
      t.date :date_to
      t.string :location
      t.float :location_lat
      t.float :location_long
      t.string :description
      t.timestamps
    end
  end
end
