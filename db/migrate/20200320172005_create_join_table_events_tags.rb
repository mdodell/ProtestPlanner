class CreateJoinTableEventsTags < ActiveRecord::Migration[6.0]
  def change
    create_join_table :events, :tags do |t|
       t.index [:event_id, :tag_id]
       t.index [:tag_id, :event_id]
    end
  end
end
