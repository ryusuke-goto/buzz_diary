class AddColumnToDiaries < ActiveRecord::Migration[7.1]
  def change
    add_column :diaries, :diary_date, :date, null: false
  end
end
