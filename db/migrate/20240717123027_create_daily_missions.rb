class CreateDailyMissions < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_missions do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :buff, default: 1, null: false
      t.timestamps
    end
  end
end
