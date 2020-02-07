class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :tags
      t.date :date_from
      t.date :date_to
      t.string :location
      t.string :dexcription
      t.time :time_from
      t.time :time_to

      t.timestamps
    end
  end
end
