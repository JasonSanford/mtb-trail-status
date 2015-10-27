class TrailsController < ApplicationController
  include TrailLoader

  before_action :load_trails, only: [:index]
  before_action :load_trail,  only: [:show]

  def index; end

  def show
    @no_footer = true
    @map       = true
  end

private
  def load_trail
    @trail = Trail.friendly.find(params[:id])
  end
end
