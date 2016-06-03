class InstagramPhotosController < ApplicationController
  load_and_authorize_resource

  def destroy
    @instagram_photo.destroy
    redirect_to admin_trail_path(@instagram_photo.trail)
  end
end
