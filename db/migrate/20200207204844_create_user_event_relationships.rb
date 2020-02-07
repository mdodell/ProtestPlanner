class CreateUserEventRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :user_event_relationships do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :role_type_id

      t.timestamps
    end
  end
end
