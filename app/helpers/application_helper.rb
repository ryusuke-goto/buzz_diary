# frozen_string_literal: true

module ApplicationHelper
  def page_title(title = '')
    base_title = 'Praise-Diary'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def show_meta_tags
    default_meta_tags if display_meta_tags.blank?
    display_meta_tags
  end

  def default_meta_tags
    {
      site: 'バズダイアリー',
      title: 'チャレンジミッション達成',
      reverse: true,
      separator: '|',   #Webサイト名とページタイトルを区切るために使用されるテキスト
      description: 'チャレンジミッションを達成したことを共有します',
      keywords: 'バズダイアリー',   #キーワードを「,」区切りで設定する
      canonical: request.original_url,   #優先するurlを指定する
      noindex: ! Rails.env.production?,
      icon: [                    #favicon、apple用アイコンを指定する
        { href: image_url('favicon.ico') },
        # { href: image_url('icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: 'バズダイアリー',
        title: 'チャレンジミッション達成',
        description: 'チャレンジミッションを達成したことを共有します', 
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: 'https://x.com/rgoto_51b',
      }
      # fb: {
      #   app_id: '自身のfacebookのapplication ID'
      # }
    }
  end
end
