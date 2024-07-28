namespace :daily_mission_processing do
  desc 'すべてのユーザーの達成済デイリーミッションを未達成に戻す'
  task reset_status: :environment do
    puts "reset_status execute!!"
    users = User.all
    users.each do |user|
      dailies = user.user_dailies.all
      dailies.each do |daily|
        daily.status
      end
    end
  end
end
