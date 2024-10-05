require 'rails_helper'

RSpec.describe "Diaries", type: :system do
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
          fill_in 'diary_body', with: 'test_content'
          # fill_in 'diary_diary_image_cache', with: 'buzz_diary_default_ogp.png'
          click_button '保存'
          expect(page).to have_content 'test_title'
          # expect(page).to have_content '(画像あり)'
          expect(current_path).to eq '/diaries'
        end
      end
    end
  end

      # context 'タイトルが未入力' do
      #   it 'タスクの新規作成が失敗する' do
      #     visit new_task_path
      #     fill_in 'Title', with: ''
      #     fill_in 'Content', with: 'test_content'
      #     click_button 'Create Task'
      #     expect(page).to have_content '1 error prohibited this task from being saved:'
      #     expect(page).to have_content "Title can't be blank"
      #     expect(current_path).to eq tasks_path
      #   end
      # end

#       context '登録済のタイトルを入力' do
#         it 'タスクの新規作成が失敗する' do
#           visit new_task_path
#           other_task = create(:task)
#           fill_in 'Title', with: other_task.title
#           fill_in 'Content', with: 'test_content'
#           click_button 'Create Task'
#           expect(page).to have_content '1 error prohibited this task from being saved'
#           expect(page).to have_content 'Title has already been taken'
#           expect(current_path).to eq tasks_path
#         end
#       end
#     end

#     describe 'タスク編集' do
#       let!(:task) { create(:task, user: user) }
#       let(:other_task) { create(:task, user: user) }
#       before { visit edit_task_path(task) }

#       context 'フォームの入力値が正常' do
#         it 'タスクの編集が成功する' do
#           fill_in 'Title', with: 'updated_title'
#           select :done, from: 'Status'
#           click_button 'Update Task'
#           expect(page).to have_content 'Title: updated_title'
#           expect(page).to have_content 'Status: done'
#           expect(page).to have_content 'Task was successfully updated.'
#           expect(current_path).to eq task_path(task)
#         end
#       end

#       context 'タイトルが未入力' do
#         it 'タスクの編集が失敗する' do
#           fill_in 'Title', with: nil
#           select :todo, from: 'Status'
#           click_button 'Update Task'
#           expect(page).to have_content '1 error prohibited this task from being saved'
#           expect(page).to have_content "Title can't be blank"
#           expect(current_path).to eq task_path(task)
#         end
#       end

#       context '登録済のタイトルを入力' do
#         it 'タスクの編集が失敗する' do
#           fill_in 'Title', with: other_task.title
#           select :todo, from: 'Status'
#           click_button 'Update Task'
#           expect(page).to have_content '1 error prohibited this task from being saved'
#           expect(page).to have_content "Title has already been taken"
#           expect(current_path).to eq task_path(task)
#         end
#       end

#       context '他ユーザーのタスク編集ページにアクセス' do
#         let!(:other_user) { create(:user, email: "other_user@example.com") }
#         let!(:other_task) { create(:task, user: other_user) }

#         it '編集ページへのアクセスが失敗する' do
#           visit edit_task_path(other_task)
#           expect(page).to have_content 'Forbidden access.'
#           expect(current_path).to eq root_path
#         end
#       end
#     end

#     describe 'タスク削除' do
#       let!(:task) { create(:task, user: user) }

#       it 'タスクの削除が成功する' do
#         visit tasks_path
#         click_link 'Destroy'
#         expect(page.accept_confirm).to eq 'Are you sure?'
#         expect(page).to have_content 'Task was successfully destroyed'
#         expect(current_path).to eq tasks_path
#         expect(page).not_to have_content task.title
#       end
#     end
#   end
end

# require 'rails_helper'

# RSpec.describe 'Tasks', type: :system do
#   let(:user) { create(:user) }
#   let(:task) { create(:task) }

#   describe 'ログイン後' do
#     before { login(user) }

#     describe 'タスク新規登録' do
#       context 'フォームの入力値が正常' do
#         it 'タスクの新規作成が成功する' do
#           visit new_task_path
#           fill_in 'Title', with: 'test_title'
#           fill_in 'Content', with: 'test_content'
#           select 'doing', from: 'Status'
#           fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
#           click_button 'Create Task'
#           expect(page).to have_content 'Title: test_title'
#           expect(page).to have_content 'Content: test_content'
#           expect(page).to have_content 'Status: doing'
#           expect(page).to have_content 'Deadline: 2020/6/1 10:30'
#           expect(current_path).to eq '/tasks/1'
#         end
#       end

#       context 'タイトルが未入力' do
#         it 'タスクの新規作成が失敗する' do
#           visit new_task_path
#           fill_in 'Title', with: ''
#           fill_in 'Content', with: 'test_content'
#           click_button 'Create Task'
#           expect(page).to have_content '1 error prohibited this task from being saved:'
#           expect(page).to have_content "Title can't be blank"
#           expect(current_path).to eq tasks_path
#         end
#       end

#       context '登録済のタイトルを入力' do
#         it 'タスクの新規作成が失敗する' do
#           visit new_task_path
#           other_task = create(:task)
#           fill_in 'Title', with: other_task.title
#           fill_in 'Content', with: 'test_content'
#           click_button 'Create Task'
#           expect(page).to have_content '1 error prohibited this task from being saved'
#           expect(page).to have_content 'Title has already been taken'
#           expect(current_path).to eq tasks_path
#         end
#       end
#     end

#     describe 'タスク編集' do
#       let!(:task) { create(:task, user: user) }
#       let(:other_task) { create(:task, user: user) }
#       before { visit edit_task_path(task) }

#       context 'フォームの入力値が正常' do
#         it 'タスクの編集が成功する' do
#           fill_in 'Title', with: 'updated_title'
#           select :done, from: 'Status'
#           click_button 'Update Task'
#           expect(page).to have_content 'Title: updated_title'
#           expect(page).to have_content 'Status: done'
#           expect(page).to have_content 'Task was successfully updated.'
#           expect(current_path).to eq task_path(task)
#         end
#       end

#       context 'タイトルが未入力' do
#         it 'タスクの編集が失敗する' do
#           fill_in 'Title', with: nil
#           select :todo, from: 'Status'
#           click_button 'Update Task'
#           expect(page).to have_content '1 error prohibited this task from being saved'
#           expect(page).to have_content "Title can't be blank"
#           expect(current_path).to eq task_path(task)
#         end
#       end

#       context '登録済のタイトルを入力' do
#         it 'タスクの編集が失敗する' do
#           fill_in 'Title', with: other_task.title
#           select :todo, from: 'Status'
#           click_button 'Update Task'
#           expect(page).to have_content '1 error prohibited this task from being saved'
#           expect(page).to have_content "Title has already been taken"
#           expect(current_path).to eq task_path(task)
#         end
#       end

#       context '他ユーザーのタスク編集ページにアクセス' do
#         let!(:other_user) { create(:user, email: "other_user@example.com") }
#         let!(:other_task) { create(:task, user: other_user) }

#         it '編集ページへのアクセスが失敗する' do
#           visit edit_task_path(other_task)
#           expect(page).to have_content 'Forbidden access.'
#           expect(current_path).to eq root_path
#         end
#       end
#     end

#     describe 'タスク削除' do
#       let!(:task) { create(:task, user: user) }

#       it 'タスクの削除が成功する' do
#         visit tasks_path
#         click_link 'Destroy'
#         expect(page.accept_confirm).to eq 'Are you sure?'
#         expect(page).to have_content 'Task was successfully destroyed'
#         expect(current_path).to eq tasks_path
#         expect(page).not_to have_content task.title
#       end
#     end
#   end
# end