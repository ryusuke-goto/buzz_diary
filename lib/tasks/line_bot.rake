namespace :line_bot do
  desc "LINEを使ってログインし、LINE通知をONにしたユーザー全てにメッセージを送る" #desc → description（説明）
  task remind: :environment do
    user = User.find_by(uid: 'Uca7769689daecc0c63bcb8b57188d3c1')
    users = []
    users.push(user.uid)
    puts users
    message = {
      type: 'text',
      text: 'こんばんは！今日はどんな日でしたか？些細なことでも構いませんので日記に投稿してみましょう！'
    }
    LineBotClient.new.client.multicast(users, message)
  end
end
