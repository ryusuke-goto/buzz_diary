# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  include LoginMacros

  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let(:diary) { create(:diary) }
  let(:comment) { create(:comment) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '日記の詳細ページにアクセス' do
        it '日記の詳細情報が表示される' do
          visit diary_path(diary)
          expect(page).to have_content diary.title
          expect(current_path).to eq diary_path(diary)
        end
      end
    end

    describe 'コメント新規作成' do
      context 'フォームの入力値が正常でもログインしていないので失敗する' do
        it 'ログイン画面に遷移する' do
          visit diary_path(diary)
          fill_in 'comment_body', with: 'test_comment'
          click_button '投稿'
          expect(page).to have_content('お持ちのLINEアカウントでログインしてください。')
          expect(current_path).to eq user_session_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }

    describe 'コメント新規作成' do
      context 'フォームの入力値が正常' do
        it '日記の新規作成が成功する' do
          visit diary_path(diary)
          fill_in 'comment_body', with: 'test_comment'
          click_button '投稿'
          expect(page).to have_content 'test_comment'
          expect(current_path).to eq diary_path(diary)
        end
      end

      context 'bodyが未入力' do
        it 'コメントの新規作成が失敗する' do
          visit diary_path(diary)
          fill_in 'comment_body', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを投稿できませんでした。'
          have_current_path(diary_path(diary), ignore_query: true)
        end
      end
    end
  end
end
