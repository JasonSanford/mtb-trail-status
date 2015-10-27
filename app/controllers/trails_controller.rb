class TrailsController < ApplicationController
  before_action :load_trails, only: [:index]
  before_action :load_trail,  only: [:show]

  def index; end

  def show; end

private
  def load_trail
    @trail = Trail.friendly.find(params[:id])
  end

  def load_trails
    @trails = Trail.all
  end
end
