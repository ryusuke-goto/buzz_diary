# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能しているか' do
      create(:user)
      comment = build(:comment)
      expect(comment).to be_valid
      expect(comment.errors).to be_empty
    end
    it 'bodyが101文字以上の場合に、バリデーションが機能してinvalidになるか' do
      user = create(:user)
      diary = create(:diary, user:)
      comment = build(:comment, user:, diary:,
                                body: '秋の夕暮れ時、空がオレンジ色に染まり、冷たい風が頬をかすめる頃、木々の葉が静かに舞い落ちる光景は、まるで時間がゆっくりと流れているかのように感じられます。その静寂な瞬間を思い出し、心が穏やかになります。')
      expect(comment).to be_invalid
    end
  end
end
