class RemoveBodyFromChallengeMission < ActiveRecord::Migration[7.1]
  def change
    remove_column :challenge_missions, :body, :text
  end
end
