# バズダイアリー

## サービス概要

「毎日の日記は一人じゃ飽きたり忘れたりするけど、みんなと褒め合いながらなら続けられる。」をテーマに、毎日の日記を記録し、共有できるアプリです。
毎日日記を投稿したくなる仕組みとして、他ユーザーの投稿をいいねする程自分の投稿にいいねがつきやすくなって承認欲求が満たされたり、AIによるまとめ機能を実装することで、一人では途中でやめたり忘れてしまう日記をユーザー全員で楽しみながら続けられるようになるサービスです。

## 画面遷移図

[画面遷移図はこちら](https://www.figma.com/design/2ySyrVRHL3vZNMMXRFyIkz/UI_graph?node-id=0-1&t=P3uW34lOTsOytd92-0 "praise_diary")

## このサービスへの思い・作りたい理由

友人から10年日記をプレゼントとしてもらい、毎日の記録をつけていこうと思っていましたが、いつの間にか忘れる日が続いて途中で続けられなくなっていました。
大きな原因としては以下が考えられると思います。

1. 常に持ち歩いているわけではないのですぐに書けない。
2. 書いていないことに気づけない。
3. 書く内容をまとめるのが難しくて時間がかかり、書くのが面倒になってしまう。
4. 継続するモチベーションが「自分がいつか読むため」だけなので忘れても後悔が小さい。

これらを解決するためには、どこでも簡単に利用でき、自分の日記を誰かと共有できるサービスが必要だと思ったのが、サービスを作りたい理由です。
具体的な解決案として以下が考えられます。

* スマホやPCなどで見やすくて日記として使いやすいアプリケーションにする。
* アプリケーションからユーザーに対して通知をして日記を忘れないようにする。
* 入力した内容をまとめる機能をAIを用いて実装する。
* 毎日続けることで、アプリ内のステータス変化が起こる。
* 日記が自分以外の人が見る場所に記録され、それが見られていることを実感できる仕組みをつくる。

特に、最後の解決策については、日々利用されている有名なSNSのような投稿に対する"いいね機能」をまず思いつきましたが、それだけでは自分の投稿に"いいね"がつかなかったり、"いいね"が少ない場合に毎日続けたいモチベーションが下がってしまう原因にもなると考えました。
そこで、他のユーザーの投稿を"いいね"したくなるような仕組みとして、以下のような機能を考えています。

* 他のユーザーの投稿を"いいね"すればするほど、自分の投稿に対して他のユーザーがくれた"いいね"の数に倍率がかかり、とても多くの"いいね"をもらえている様な気分になる。
* "いいね"を続けることで自分のアプリ内ステータスの変化などが起こる。
これらにより、毎日続けられる仕組みを持った日記サービスを作ることができると思います。

## ユーザー層について

1. 日記をつけたいけど毎日続けられない人
2. 承認欲求を満たしたい人
1のユーザー層については、このサービスのコンセプトが「毎日続けたくなる日記」なので、楽しくサービスを使っていただけると思っています。
2のユーザー層については、自分の投稿に対してたくさんの"いいね"が貰えることに対して喜びやモチベーションになる人も多いと思うので、"いいね"をたくさんもらいやすいアプリの仕組みを楽しんでいただけると思っています。

## サービスの利用イメージ

ユーザーがこのサービスをどのように利用できて、それによってどんな価値を得られるか。

* 毎日忘れずに日記をつけることができ、思い出を振り返ることができる。
* 他の人の投稿を見ることで日常の出来事を共有できる。
* 他の人の投稿に"いいね"をすることで、次の自分の投稿に他ユーザーから貰える"いいね"に倍率がかかるのでユーザー同士で承認欲求が満たされる。お互いの"いいね"がその人のモチベーションになり、日記を継続できる。
* 日記投稿を続けることでアプリのステータスが変化するため、自分の日記を育てる気持ちでサービスを楽しめる。

## ユーザーの獲得について

想定したユーザー層に対してそれぞれどのようにサービスを届けるのか。

* まずは日記をつけたいと思っている友人などに教えてサービスを利用してもらう。
* ユーザーが一定数のいいねを送るor貰うと、別のSNSサービスにその功績をシェアできる機能を用意することで、サービスを使っていないユーザーにも知ってもらえるようにしたい。

## サービスの差別化ポイント・推しポイント

* 他のユーザーとの日記シェア機能
  日記は、他のユーザーが作成した日記とともにアプリ内で公開されます。誰かの日記を楽しみにする気持ちや、自分の日記を誰かが待っていると思う気持ちが日記を続ける力の原動力になると思っています。

* "いいね"倍率機能
  他ユーザーから日記に対して"いいね"をもらうことができます。"いいね"をもらうことで、承認欲求が満たされ続けるモチベーションになると考えています。
  しかし、"いいね"がもらえなかったりすると逆にネガティブな感情が生まれて継続できなくなるきっかけにもなりうるため、本サービスではいいねしたユーザー数に応じて倍率がかかることでユーザー同士が"いいね"をしたくなる仕組みを用意することで、すべてのユーザーが継続して日記を投稿したくなる体験を提供できるのが、他のサービスと差別化できるポイントになると考えています。

* ミッション機能と、達成に伴う見た目の変化
  アプリを続ける目標として、ユーザーに対してミッションを用意しています。
  「日記投稿」「コメント作成」「いいねする」等の回数を重ねていくことで達成することができ、徐々にアイコン周りの色やハートの色、背景色が変化していきます。
  ミッションを達成して見た目の変化を楽しむことも本アプリの醍醐味にしています。

## 機能候補

現状作ろうと思っている機能、案段階の機能。

### MVPリリース時までに作っていたいもの

* 日記作成機能
* 日記振り返り機能(カレンダー形式)
* 写真追加機能
* ユーザー登録機能
* プロフィール作成/編集機能
* ログイン/ログアウト機能
* アプリ内で投稿が共有される機能(掲示板のように)
* 投稿された日、作成者などのフィルタ(検索)機能
* "いいね"が何回もできる機能
* 複数の投稿に一気に"いいね"できる機能
* "いいね"を他の人にすればするほど、次の自分の投稿に倍率がかかる(例："いいね"を5人の投稿にするごとに2倍)
* LINEログイン認証
* 毎日忘れないように、LINE通知を設定できる機能(例：22時から23時で設定すれば、アプリはその間の時間でユーザーのデバイスに日記を書いて！と通知する。)

### 本リリースまでに作っていたいもの

* ログインした状態で、いいねを特定の人数、回数以上するといいねした時のエフェクトが変化する機能(適用するCSSが選べる等)
* ログインした状態で、投稿を続けた期間に応じてフレームなどが変化する機能
* ユーザーがすべきアクションを「x人の投稿をいいねしよう」といったミッションとして確認、管理できる機能
* ユーザーが一定以上の"いいね"や投稿ができていると、Xでシェアして自慢できる機能
* レスポンシブ対応

## 使用技術

| カテゴリ | 技術 |
| ---- | ---- |
| フロントエンド | Ruby on Rails Vanilla JS |
| CSSフレームワーク | Tailwind CSS + daisy UI |
| バックエンド | Ruby 3.3.0 / Ruby on Rails 7.1.3.2  |
| データベース | PostgreSQL 16.3 |
| 環境構築| docker |
| インフラ | Render/Amazon S3|
| その他 | GitHub |

## 技術選定理由

### フロントエンド

フロントエンド開発の基本的な概念や技術をしっかりと理解するため、Vanilla JavaScriptを採用しました。
Vanilla JSはフレームワークやライブラリに依存せずに純粋なJavaScriptのスキルを磨くことができるため、後にフレームワークを学ぶ際にもその基礎知識が役立つと思っています。
開発におけるメリットとしては以下が考えられます。

* 追加のライブラリを使用しないため、アプリケーションのパフォーマンスが軽量で高速になる。
これらのメリットは、本サービスの強みである「どこでも簡単に利用できる」という仕様にもマッチすると思っています。

### CSSフレームワーク

Railsとして選択でき、カスタマイズ性の高いフレームワークとしてTailwind、UIライブラリとしてdaisy UIを採用しました。

### バックエンド

Ruby の言語としての機能の豊富さに加え、フレームワークのRuby on Railsは基本理念であるConvention over Configuration（設定より規約）に則って定義の記述を軽減できるため、開発期間を短縮につながると考え採用しました。

### データベース

インフラにRenderを採用したため、Renderで対応している点や、機能の豊富さなどからDBMSのPostgreSQLを採用しました。

### 環境構築

受講しているプログラミングスクールのコミュニティや講師の方にレビューしてもらう際に、ローカル開発環境を構築しやすいようにDockerを採用しました。

### インフラ

AWSを検討しましたが、従量課金制なので個人サービスとしてはサーバー運用コストの見通しが立てにくいことが懸念点でした。そのため今回は画像を保存するためにS3のみ利用し、他のインフラは月額料金で固定されているサービスを採用する方針にしました。
その方針に加えて、パフォーマンスを少しでも速くするためにデプロイするリージョンができるだけ日本に近い地域にあることを条件に検討した結果、Renderを採用しました。

### その他

本サービスはGitHubを使ってバージョン管理をしています。

## 機能の実装方針予定

一般的なCRUD以外の実装予定の機能については、以下のAPIを使用して実装する予定です。

| 機能 | API |
| ---- | ---- |
| 文章要約 | Open AI API |
| ユーザーへの通知 | LINE通知機能(LINE Messaging API) |
| LINE認証 | OAuth 2.0 |
| Xへのシェア機能 | Twitter API v2 |

## ER図

[![Image from Gyazo](https://i.gyazo.com/13b810a560705ccd4b82868613248482.png)](https://gyazo.com/13b810a560705ccd4b82868613248482)
