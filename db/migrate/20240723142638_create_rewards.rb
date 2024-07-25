class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.references :user, foreign_key: true
      t.integer :like_css, default: 0, null: false
      t.integer :diary_css, default: 0, null: false
      t.integer :theme_css, default: 0, null: false

      t.timestamps
    end
  end
end
