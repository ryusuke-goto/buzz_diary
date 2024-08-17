# frozen_string_literal: true

class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :image, :string
  end
end
