# frozen_string_literal: true

namespace :daily_mission_processing do
  desc 'すべてのユーザーの達成済デイリーミッションを未達成に戻す'
  task reset_status: :environment do
    puts 'reset_status execute!!'
    users = User.all
    users.each do |user|
      dailies = user.user_dailies.all
      puts "user_id: #{user.id} checking..."
      dailies.each do |daily|
        next unless daily.status

        daily.update(status: false)
        puts "daily_id:#{daily.daily_mission_id}"
        puts 'status: true => false'
      end
    end
  end
end
