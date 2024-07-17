class CreateChallengeMissions < ActiveRecord::Migration[7.1]
  def change
    create_table :challenge_missions do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :buff, default: 1, null: false
      t.integer :like_css
      t.integer :diary_css
      t.integer :theme_css
      t.timestamps
    end
  end
end
