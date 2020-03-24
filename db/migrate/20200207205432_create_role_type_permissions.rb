class CreateRoleTypePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :role_type_permissions, id: false, primary_key: :id do |t|
      t.integer :id
      t.string :role_type
      t.boolean :modify_event
      t.boolean :delete_event

      t.timestamps
    end
  end
end
