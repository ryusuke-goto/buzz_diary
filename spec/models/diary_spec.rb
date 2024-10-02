require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能しているか' do
      user = create(:user)
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
    it 'titleが被らない場合にバリデーションエラーが起きないか' do
      user = create(:user)
      task1 = create(:task)
      task2 = create(:task)
      expect(task2).to be_valid
      expect(task2.errors).to be_empty
    end
    it 'titleがない場合にバリデーションが機能してinvalidになるか' do
      user = create(:user)
      task = build(:task, title: "")
      expect(task).to be_invalid
    end
    it 'statusがない場合にバリデーションが機能してinvalidになるか' do
      user = create(:user)
      task = build(:task, status: "")
      expect(task).to be_invalid
    end
    it 'titleが被った場合にuniqueのバリデーションが機能してinvalidになるか' do
      user = create(:user)
      task1 = create(:task)
      task2 = build(:task, title: task1.title)
      expect(task2).to be_invalid
    end
  end
end

