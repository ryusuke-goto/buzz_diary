# frozen_string_literal: true

class MissionsController < ApplicationController
  before_action :authenticate_user!, only: %i[show]
  ## 設定したprepare_meta_tagsをprivateにあってもpostコントローラー以外にも使えるようにする
  helper_method :prepare_meta_tags

  def show
    case params[:type]
    when 'daily'
      @missions = current_user.my_dailies.order(id: :asc)
      @mission_status = current_user.user_dailies.index_by(&:daily_mission_id)
      render partial: 'shared/daily_missions', locals: { daily_missions: @missions, daily_status: @mission_status }
    when 'challenge'
      @missions = current_user.my_challenges.order(id: :asc)
      @mission_status = current_user.user_challenges.index_by(&:challenge_mission_id)
      render partial: 'shared/challenge_missions',
             locals: { challenge_missions: @missions, challenge_status: @mission_status }
    else
      render plain: 'Invalid mission type', status: :bad_request
    end
  end

  private

  def prepare_meta_tags(mission)
    ## このimage_urlにMiniMagickで設定したOGPの生成した合成画像を代入する
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(mission.title)}"
    set_meta_tags og: {
                    site_name: 'バズダイアリー',
                    title: mission.title,
                    description: 'ユーザーが達成したチャレンジミッションの共有です',
                    type: 'website',
                    url: request.original_url,
                    image: image_url,
                    locale: 'ja-JP'
                  },
                  twitter: {
                    card: 'summary_large_image',
                    site: '@https://x.com/rgoto_51b',
                    image: image_url
                  }
  end
end
