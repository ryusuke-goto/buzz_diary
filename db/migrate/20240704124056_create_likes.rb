class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.integer :count, default: 0, null: false
      t.references :user, foreign_key: true
      t.references :diary, foreign_key: true
      t.timestamps
    end
  end
end
