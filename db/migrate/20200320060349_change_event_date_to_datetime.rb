class ChangeEventDateToDatetime < ActiveRecord::Migration[6.0]
  def change
    change_column :events, :date_from, :datetime
    change_column :events, :date_to, :datetime
  end
end
