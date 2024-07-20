class AddDescriptionToChallengeMission < ActiveRecord::Migration[7.1]
  def change
    add_column :challenge_missions, :description, :text, null: false
  end
end
