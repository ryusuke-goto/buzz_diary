# frozen_string_literal: true

class AddRemindToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remind, :boolean, default: false
  end
end
