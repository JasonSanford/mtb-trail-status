class HomeController < ApplicationController
  include TrailLoader

  before_action :redirect_authenticated, only: [:index]
  before_action :load_trails, only: [:index]

  def index
    @map = true
  end

private
  def redirect_authenticated
    redirect_to(trails_path) if current_user
  end
end
