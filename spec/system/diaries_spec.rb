# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Diaries', type: :system do
  include LoginMacros

  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let(:diary) { create(:diary) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '日記の新規作成ページにアクセス' do
        it '新規作成ページへのアクセスが失敗する' do
          visit new_diary_path
          expect(page).to have_content('お持ちのLINEアカウントでログインしてください。')
          expect(current_path).to eq user_session_path
        end
      end

      context '日記の編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_diary_path(diary)
          expect(page).to have_content('お持ちのLINEアカウントでログインしてください。')
          expect(current_path).to eq user_session_path
        end
      end

      context '日記の詳細ページにアクセス' do
        it '日記の詳細情報が表示される' do
          visit diary_path(diary)
          expect(page).to have_content diary.title
          expect(current_path).to eq diary_path(diary)
        end
      end

      context '日記の一覧ページにアクセス' do
        it 'すべてのユーザーの日記が表示される' do
          diary_list = create_list(:diary, 3)
          visit diaries_path
          expect(page).to have_content diary_list[0].title
          expect(page).to have_content diary_list[1].title
          expect(page).to have_content diary_list[2].title
          expect(current_path).to eq diaries_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }

    describe '日記新規作成' do
      context 'フォームの入力値が正常' do
        it '日記の新規作成が成功する' do
          visit new_diary_path
          fill_in 'diary_title', with: 'test_title'
          fill_in 'diary_body', with: 'test_body'
          attach_file('diary_diary_image', Rails.root.join('spec/images/correct_test_image.png'))
          click_button '保存'
          expect(page).to have_content 'test_title'
          expect(page).to have_content '(画像あり)'
          expect(current_path).to eq '/diaries'
        end

        it '画像のみ未入力でも日記の新規作成が成功する' do
          visit new_diary_path
          fill_in 'diary_title', with: 'test_title'
          fill_in 'diary_body', with: 'test_body'
          click_button '保存'
          expect(page).to have_content 'test_title'
          expect(current_path).to eq '/diaries'
        end
      end

      context 'タイトルが未入力' do
        it '日記の新規作成が失敗する' do
          visit new_diary_path
          fill_in 'diary_title', with: ''
          fill_in 'diary_body', with: 'test_body'
          click_button '保存'
          expect(page).to have_content '日記を投稿できませんでした。'
          expect(page).to have_content 'タイトルが入力されていません。'
          expect(current_path).to eq diaries_path
        end
      end

      context '登録済のdiary_dateを選択' do
        it 'タスクの新規作成が失敗する' do
          # ログインしたユーザーでdiary1を作成
          diary1 = create(:diary, user:)

          visit new_diary_path
          fill_in 'diary_diary_date', with: diary1.diary_date.strftime('%Y-%m-%d')
          fill_in 'diary_title', with: 'test_title'
          fill_in 'diary_body', with: 'test_body'
          click_button '保存'
          expect(page).to have_content '日記を投稿できませんでした。'
          expect(page).to have_content '日付けは既に使用されています。'
          expect(current_path).to eq diaries_path
        end
      end
    end

    describe '日記編集' do
      let!(:diary) { create(:diary, user:) }
      let(:other_diary) { create(:diary, user:) }
      before { visit edit_diary_path(diary) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          fill_in 'diary_title', with: 'update_title'
          fill_in 'diary_body', with: 'update_body'
          attach_file('diary_diary_image', Rails.root.join('spec/images/correct_test_image.png'))
          click_button '更新'
          expect(page).to have_content 'update_title'
          expect(page).to have_content '日記を更新しました'
          expect(current_path).to eq diary_path(diary)
        end
      end

      context 'タイトルが未入力' do
        it '日記の編集が失敗する' do
          fill_in 'diary_title', with: ''
          fill_in 'diary_body', with: 'update_body'
          attach_file('diary_diary_image', Rails.root.join('spec/images/correct_test_image.png'))
          click_button '更新'
          expect(page).to have_content 'タイトルが入力されていません。'
          expect(page).to have_content '日記を更新出来ませんでした・・・'
          expect(current_path).to eq diary_path(diary)
        end
      end

      context '本文が未入力' do
        it '日記の編集が失敗する' do
          fill_in 'diary_title', with: 'update_title'
          fill_in 'diary_body', with: ''
          attach_file('diary_diary_image', Rails.root.join('spec/images/correct_test_image.png'))
          click_button '更新'
          expect(page).to have_content '本文が入力されていません。'
          expect(page).to have_content '日記を更新出来ませんでした・・・'
          expect(current_path).to eq diary_path(diary)
        end
      end

      context '他ユーザーの日記編集ページにアクセス' do
        let!(:other_user) { create(:user, email: 'other_user@example.com') }
        let!(:other_diary) { create(:diary, user: other_user) }

        it '編集ページへのアクセスが失敗する' do
          visit edit_diary_path(other_diary)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq root_path
        end
      end
    end

    # describe '日記削除' do
    #   let!(:diary) { create(:diary, user: user) }

    #   it '日記の削除が成功する' do
    #     visit diary_path(diary)
    #     # 削除リンクをクリックし、確認ダイアログでOKを選択
    #     accept_confirm do
    #       click_link 'destroy'
    #     end
    #     expect(page).to have_content '日記を削除しました'
    #     expect(current_path).to eq diaries_path
    #   end
    # end
  end
end
