class ChangeEventDateToEventStartDateInEvents < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :event_date, :start_date
    add_column :events, :end_date, :date, null: false
  end
end
