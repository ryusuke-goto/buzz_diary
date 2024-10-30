# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'テストくん' }
    sequence(:email) { |n| "test_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
