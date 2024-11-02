# frozen_string_literal: true

class ModifyUsersTable < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :provider
      t.integer :like_css
      t.text :access_token
    end
  end
end
