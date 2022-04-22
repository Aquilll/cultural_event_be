class AddUniqueIndexToEvents < ActiveRecord::Migration[7.0]
  def change

    add_index :events, [:title, :start_date, :end_date, :web_source], unique: true
  end
end
