# frozen_string_literal: true

class MissionsController < ApplicationController
  def show
    case params[:type]
    when 'daily'
      @missions = DailyMission.all
      render partial: 'shared/daily_missions', locals: { daily_missions: @missions }
    when 'challenge'
      @missions = ChallengeMission.all
      render partial: 'shared/challenge_missions', locals: { challenge_missions: @missions }
    else
      render plain: 'Invalid mission type', status: :bad_request
    end
  end
end
