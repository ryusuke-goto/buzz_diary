# frozen_string_literal: true

class LineBotController < ApplicationController
  def callback
    puts '======='
    puts request.body.read
    puts '======='
  end

  # private

  # def client
  #   @client ||= Line::Bot::Client.new { |config|
  #     config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
  #     config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  #   }
  # end
end
