class CreateBuffs < ActiveRecord::Migration[7.1]
  def change
    create_table :buffs do |t|
      t.integer :daily_buff, default: 0, null: false
      t.integer :challenge_buff, default: 1, null: false
      t.integer :sum_buff, default: 1, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
