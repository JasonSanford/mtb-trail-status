class TrailsController < ApplicationController
  include TrailLoader

  authorize_resource

  before_action :load_trails, only: [:index]
  before_action :load_trail,  only: [:show, :admin, :create_photo]
  before_action :set_nav, :set_map

  def index
    @page_title = 'Charlotte Mountain Bike Trail Statuses'

    respond_to do |format|
      format.html { render 'trails/index' }
      format.geojson { render json: {type: 'FeatureCollection', features: @trails.map{ |trail| trail.geojson }}}
    end
  end

  def show
    @page_title = @trail.display_name
  end

  def create_photo
    @instagram_photo = InstagramPhoto.new(instagram_photo_params.merge!(trail: @trail))

    if @instagram_photo.save
      @instagram_photo.process!
      flash[:success] = 'Instagram photo added!'
      redirect_to admin_trail_path(@trail)
    else
      flash[:error] = "There was a problem adding that photo. :( - #{@instagram_photo.errors.full_messages.join(' - ')}"
      redirect_to admin_trail_path(@trail)
    end
  end

  def admin
    @admin = true
    @instagram_photo = InstagramPhoto.new
  end

private
  def instagram_photo_params
    params.require(:instagram_photo).permit(:short_code)
  end

  def set_nav
    @nav = 'trails'
  end

  def set_map
    @map = true
  end
end
