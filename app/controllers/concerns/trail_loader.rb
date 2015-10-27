module TrailLoader
  extend ActiveSupport::Concern

private
  def load_trails
    @trails = Trail.all
  end
end
