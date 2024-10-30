# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能しているか' do
      create(:user)
      diary = build(:diary)
      expect(diary).to be_valid
      expect(diary.errors).to be_empty
    end
    it 'diary_dateが被らない場合にバリデーションエラーが起きないか' do
      create(:user)
      create(:diary)
      diary2 = create(:diary, diary_date: (Time.zone.today + 1.day))
      expect(diary2).to be_valid
      expect(diary2.errors).to be_empty
    end
    it 'titleがない場合にバリデーションが機能してinvalidになるか' do
      create(:user)
      diary = build(:diary, title: '')
      expect(diary).to be_invalid
    end
    it 'bodyがない場合にバリデーションが機能してinvalidになるか' do
      create(:user)
      diary = build(:diary, body: '')
      expect(diary).to be_invalid
    end
    it '許可されていない拡張子のdiary_imageは無効となるか' do
      create(:user)
      diary = build(:diary, diary_image: File.open(Rails.root.join('spec/images/test_image.webp')))
      expect(diary).to be_invalid
      expect(diary.errors[:diary_image]).to include('画像の拡張子はjpg jpeg gif pngのみに対応しています。')
    end
    it 'diary_dateが被った場合にuniqueのバリデーションが機能してinvalidになるか' do
      user = create(:user)
      diary1 = create(:diary, user:)
      diary2 = build(:diary, diary_date: diary1.diary_date, user:)
      expect(diary2).to be_invalid
    end
    it 'titleが31文字以上の場合に、バリデーションが機能してinvalidになるか' do
      user = create(:user)
      diary = build(:diary, user:, title: '澄んだ秋空の下、色とりどりの紅葉が風に揺れ、心地よい季節の訪れを感じます。')
      expect(diary).to be_invalid
    end
    it 'bodyが201文字以上の場合に、バリデーションが機能してinvalidになるか' do
      user = create(:user)
      diary = build(:diary, user:,
                            body: '秋の澄んだ空気が心地よく感じられるこの季節、木々の葉は次第に色づき、鮮やかな赤や黄色のカーペットのように地面を彩ります。日々の忙しさの中でも、この瞬間に目を向けることで心が穏やかになります。公園のベンチに座り、温かいコーヒーを片手に読書を楽しむ時間は、まさに贅沢なひとときです。鳥のさえずりや、風に揺れる木々の音に耳を傾けると、自然との一体感を感じ、日常の喧騒を忘れることができる大切な時間となります。')
      expect(diary).to be_invalid
    end
  end
end
