class CreateUserDailies < ActiveRecord::Migration[7.1]
  def change
    create_table :user_dailies do |t|
      t.boolean :status, default: false
      t.references :user, foreign_key: true
      t.references :daily_mission, foreign_key: true
      t.timestamps
    end
  end
end
