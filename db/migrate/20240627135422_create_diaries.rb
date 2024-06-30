# frozen_string_literal: true

class CreateDiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :diaries do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :diary_image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
