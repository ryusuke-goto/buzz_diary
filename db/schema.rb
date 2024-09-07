# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_824_175_619) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'buffs', force: :cascade do |t|
    t.integer 'daily_buff', default: 0, null: false
    t.integer 'challenge_buff', default: 1, null: false
    t.integer 'sum_buff', default: 1, null: false
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_buffs_on_user_id'
  end

  create_table 'challenge_missions', force: :cascade do |t|
    t.string 'title', null: false
    t.integer 'buff', default: 1, null: false
    t.integer 'like_css'
    t.integer 'diary_css'
    t.integer 'theme_css'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'description', null: false
  end

  create_table 'comments', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'diary_id'
    t.text 'body'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['diary_id'], name: 'index_comments_on_diary_id'
    t.index ['user_id'], name: 'index_comments_on_user_id'
  end

  create_table 'daily_missions', force: :cascade do |t|
    t.string 'title', null: false
    t.integer 'buff', default: 1, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'description', null: false
  end

  create_table 'diaries', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'body', null: false
    t.string 'diary_image'
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.date 'diary_date', null: false
    t.index ['user_id'], name: 'index_diaries_on_user_id'
  end

  create_table 'likes', force: :cascade do |t|
    t.integer 'count', default: 0, null: false
    t.bigint 'user_id'
    t.bigint 'diary_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['diary_id'], name: 'index_likes_on_diary_id'
    t.index ['user_id'], name: 'index_likes_on_user_id'
  end

  create_table 'rewards', force: :cascade do |t|
    t.bigint 'user_id'
    t.integer 'like_css', default: 0, null: false
    t.integer 'diary_css', default: 0, null: false
    t.integer 'theme_css', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_rewards_on_user_id'
  end

  create_table 'user_challenges', force: :cascade do |t|
    t.boolean 'status', default: false
    t.bigint 'user_id'
    t.bigint 'challenge_mission_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['challenge_mission_id'], name: 'index_user_challenges_on_challenge_mission_id'
    t.index ['user_id'], name: 'index_user_challenges_on_user_id'
  end

  create_table 'user_dailies', force: :cascade do |t|
    t.boolean 'status', default: false
    t.bigint 'user_id'
    t.bigint 'daily_mission_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['daily_mission_id'], name: 'index_user_dailies_on_daily_mission_id'
    t.index ['user_id'], name: 'index_user_dailies_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'provider'
    t.string 'uid'
    t.string 'name'
    t.boolean 'remind', default: false
    t.string 'image'
    t.integer 'like_css', default: 0
    t.integer 'diary_css', default: 0
    t.integer 'theme_css', default: 0
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'buffs', 'users'
  add_foreign_key 'comments', 'diaries'
  add_foreign_key 'comments', 'users'
  add_foreign_key 'diaries', 'users'
  add_foreign_key 'likes', 'diaries'
  add_foreign_key 'likes', 'users'
  add_foreign_key 'rewards', 'users'
  add_foreign_key 'user_challenges', 'challenge_missions'
  add_foreign_key 'user_challenges', 'users'
  add_foreign_key 'user_dailies', 'daily_missions'
  add_foreign_key 'user_dailies', 'users'
end
