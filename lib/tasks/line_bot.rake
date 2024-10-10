# frozen_string_literal: true

namespace :line_bot do
  desc 'LINEを使ってログインし、LINE通知をONにしたユーザー全てにメッセージを送る' # desc → description（説明）
  task remind: :environment do
    users = User.where(remind: true)
    puts users
    to_users = []
    users.each do |user|
      to_users.push(user.uid)
    end
    message = {
      type: 'text',
      text: 'こんばんは！今日はどんな日でしたか？些細なことでも構いませんので日記に投稿してみましょう！https://buzzdiaries.com'
    }
    LineBotClient.new.client.multicast(to_users, message)
  end
end
