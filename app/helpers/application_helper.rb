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

  def assign_meta_tags(options = {})
    defaults = t('meta_tags.defaults')
    options.reverse_merge!(defaults)
    site = options[:site]
    title = options[:title]
    description = options[:description]
    keywords = options[:keywords]
    image = options[:image].presence || image_url('ogp.png')
    configs = {
      separator: '|',
      reverse: true,
      site:,
      title:,
      description:,
      keywords:,
      canonical: request.original_url,
      icon: {
        href: image_url('placeholder.png')
      },
      og: {
        type: 'website',
        title: title.presence || site,
        description:,
        url: request.original_url,
        image:,
        site_name: site
      },
      twitter: {
        site:,
        card: 'summary_large_image',
        image:
      }
    }
    set_meta_tags(configs)
  end
end
