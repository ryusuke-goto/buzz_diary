# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 5.times do
#   user = User.create!(name: Faker::Name.name,
#                       email: Faker::Internet.unique.email,
#                       password: 'password',
#                       password_confirmation: 'password')
#   puts "\"#{user.name}\" has created!"
# end

User.ids

10.times do |index|
  user = User.find(11)
  diary = user.diaries.create!(title: "今日は連勤#{index}日目だった", body: "まだまだ#{index}日ぐらい頑張れそう！", diary_date: Time.zone.today)
  logger.info "\"#{diary.title}\" has created!"
end
