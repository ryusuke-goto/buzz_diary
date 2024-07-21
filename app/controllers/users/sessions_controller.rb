# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    after_action :buff_process, only: :create
    after_action :missions_process, only: :create
    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
    private

    def buff_process
      Rails.logger.info "buff_process executed"
      current_user.ensure_buff_exists
    end

    def missions_process
      Rails.logger.info "missions_process executed"
      DailyMission.check_record_user_dailies(user_id: current_user.id)
      ChallengeMission.check_record_user_challenges(user_id: current_user.id)
    end

  end
end
