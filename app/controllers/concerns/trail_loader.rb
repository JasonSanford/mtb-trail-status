module TrailLoader
  extend ActiveSupport::Concern

private
  def load_trails
    @trails = Trail.all.order(:status, :name)
  end
end
