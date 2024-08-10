namespace :line_bot do
  desc "LINEを使ってログインし、LINE通知をONにしたユーザー全てにメッセージを送る" #desc → description（説明）
  task remind: :environment do #task_nameは自由につけられる
    # 実行したい処理を記述する場所
    user = User.find_by(uid: 'Uca7769689daecc0c63bcb8b57188d3c1')
    users = []
    users.push(user.uid)
    puts users
    message = {
      type: 'text',
      text: '今日の思い出を日記に投稿しませんか？'
    }
    LineBotClient.new.client.multicast(users, message)
  end
end
