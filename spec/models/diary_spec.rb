require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能しているか' do
      user = create(:user)
      diary = build(:diary)
      expect(diary).to be_valid
      expect(diary.errors).to be_empty
    end
    it 'diary_dateが被らない場合にバリデーションエラーが起きないか' do
      user = create(:user)
      diary1 = create(:diary)
      diary2 = create(:diary, diary_date: (Time.zone.today + 1.day))
      expect(diary2).to be_valid
      expect(diary2.errors).to be_empty
    end
    it 'titleがない場合にバリデーションが機能してinvalidになるか' do
      user = create(:user)
      diary = build(:diary, title: "")
      expect(diary).to be_invalid
    end
    it 'bodyがない場合にバリデーションが機能してinvalidになるか' do
      user = create(:user)
      diary = build(:diary, body: "")
      expect(diary).to be_invalid
    end
    it '許可されていない拡張子のdiary_imageは無効となるか' do
      user = create(:user)
      diary = build(:diary, diary_image: File.open(Rails.root.join('spec/images/test_image.webp')))
      expect(diary).to be_invalid
      expect(diary.errors[:diary_image]).to include('画像の拡張子はjpg jpeg gif pngのみに対応しています。')
    end
    it 'diary_dateが被った場合にuniqueのバリデーションが機能してinvalidになるか' do
      user = create(:user)
      diary1 = create(:diary, user: user)
      diary2 = build(:diary, diary_date: diary1.diary_date, user: user)
      expect(diary2).to be_invalid
    end
  end
end

