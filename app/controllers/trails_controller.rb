class TrailsController < ApplicationController
  include TrailLoader

  before_action :load_trails, only: [:index]
  before_action :load_trail,  only: [:show]

  def index
    respond_to do |format|
      format.html
      format.geojson { render json: {type: 'FeatureCollection', features: @trails.map{ |trail| trail.geojson }}}
    end
  end

  def show
    @no_footer = true
    @map       = true
  end
end
