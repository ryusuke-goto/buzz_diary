# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def ogp
    text = ogp_params[:text]
    image = OgpCreator.build(text).tempfile.open.read
    send_data image, type: 'image/png', disposition: 'inline'
  end

  private

  def ogp_params
    params.permit(:text)
  end
end
