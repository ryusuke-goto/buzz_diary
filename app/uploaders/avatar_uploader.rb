# frozen_string_literal: true

class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  include CarrierWave::MiniMagick
  process resize_to_limit: [500, 500]

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # ここでファイル形式を指定する
  def filename
    original_filename
  end
end
