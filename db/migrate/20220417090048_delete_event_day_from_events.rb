class DeleteEventDayFromEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :event_day
  end
end
