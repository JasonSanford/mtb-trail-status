class HomeController < ApplicationController
  include TrailLoader

  before_action :load_trails, only: [:index]

  def index
  end
end
