class HomeController < ApplicationController
  include TrailLoader

  before_action :load_trails, only: [:index]

  def index
    @map = true
  end
end
