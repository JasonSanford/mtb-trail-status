class TrailsController < ApplicationController
  include TrailLoader

  before_action :load_trails, only: [:index]
  before_action :load_trail,  only: [:show]
  before_action :set_nav, :set_map

  def index
    respond_to do |format|
      format.html { render 'trails/index' }
      format.geojson { render json: {type: 'FeatureCollection', features: @trails.map{ |trail| trail.geojson }}}
    end
  end

  def show
    @no_footer = true
  end

private
  def set_nav
    @nav = 'trails'
  end

  def set_map
    @map = true
  end
end
