# frozen_string_literal: true

class AddColumnAccessToken < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :access_token, :text
    add_column :users, :refresh_token, :text
  end
end
