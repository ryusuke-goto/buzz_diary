# frozen_string_literal: true

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: 'ap-northeast-1'
  }
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory = ENV['DIRECTORY_NAME']
  config.storage = :fog
  config.fog_public = false
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
end
