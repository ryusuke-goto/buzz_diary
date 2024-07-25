# frozen_string_literal: true

# ApplicationController→Devise::OmniauthCallbacksController
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line = basic_action

  private

  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth['provider'], uid: @omniauth['uid'])
      if @profile.email.blank?
        email = @omniauth['info']['email'] || "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
        @profile = current_user || User.create!(provider: @omniauth['provider'], uid: @omniauth['uid'], email:,
                                                name: @omniauth['info']['name'], password: Devise.friendly_token[0, 20])
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
    Rails.logger.info "buff_process executed"
    user.ensure_buff_exists
  end

  def reward_process(user)
    Rails.logger.info "reward_process executed"
    user.ensure_reward_exists
  end

  def missions_process(user)
    Rails.logger.info "missions_process executed"
    DailyMission.check_record_user_dailies(user.id)
    ChallengeMission.check_record_user_challenges(user.id)
  end
end
