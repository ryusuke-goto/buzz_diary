# frozen_string_literal: true

# ApplicationController→Devise::OmniauthCallbacksController
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line = basic_action

  private

  def basic_action
    @omniauth = request.env['omniauth.auth']
    @auth_token = @omniauth['credentials']['token']
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth['provider'], uid: @omniauth['uid'])
      if @profile.new_record?
        email = @omniauth['info']['email'] || "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
        @profile.assign_attributes(
          email: email,
          name: @omniauth['info']['name'],
          image: @omniauth['info']['image'],
          password: Devise.friendly_token[0, 20],
          access_token: @omniauth['credentials']['token'],
          refresh_token: @omniauth['credentials']['refresh_token']
        )
      else
        # 既存ユーザーのトークンを更新
        @profile.update(
          access_token: @omniauth['credentials']['token'],
          refresh_token: @omniauth['credentials']['refresh_token']
        )
      end
      @profile.set_values(@omniauth)
      @profile.save!
      sign_in(:user, @profile)
      buff_process(@profile)
      reward_process(@profile)
      missions_process(@profile)
    end
    flash[:notice] = 'ログインしました'
    redirect_to diaries_path
  end

  def fake_email(_uid, _provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  def buff_process(user)
    Rails.logger.info 'buff_process executed'
    user.ensure_buff_exists
  end

  def reward_process(user)
    Rails.logger.info 'reward_process executed'
    user.ensure_reward_exists
  end

  def missions_process(user)
    Rails.logger.info 'missions_process executed'
    DailyMission.check_record_user_dailies(user.id)
    ChallengeMission.check_record_user_challenges(user.id)
  end
end
