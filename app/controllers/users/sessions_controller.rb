# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    after_action :buff_reward_missions_process, only: :create
    after_action :auth_token, only: :create
    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      super
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    def test_sign_in; end

    # テストユーザー用のサインイン処理
    def test_sign_in_user
      user = User.find_by(email: params[:email])
      if user&.valid_password?(params[:password])
        sign_in(user)
        redirect_to root_path, notice: 'テストユーザーとしてログインしました。'
      else
        flash.now[:alert] = '無効なメールアドレスまたはパスワードです。'
        render :test_sign_in
      end
    end

    private

    def buff_reward_missions_process
      Rails.logger.info 'buff_process executed'
      current_user.ensure_buff_exists

      Rails.logger.info 'reward_process executed'
      current_user.ensure_reward_exists

      Rails.logger.info 'missions_process executed'
      DailyMission.check_record_user_dailies(current_user.id)
      ChallengeMission.check_record_user_challenges(current_user.id)
    end
  end
end
