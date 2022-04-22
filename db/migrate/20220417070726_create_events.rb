class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title, null: false, index: true
      t.text :description
      t.string :event_day, null: false
      t.date :event_date, null: false
      t.integer :web_source, null: false
      t.timestamps
    end
  end
end
