# frozen_string_literal: true

class AddColumnCssToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :like_css, :integer, default: 0
    add_column :users, :diary_css, :integer, default: 0
    add_column :users, :theme_css, :integer, default: 0
  end
end
