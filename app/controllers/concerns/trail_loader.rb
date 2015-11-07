module TrailLoader
  extend ActiveSupport::Concern

private
  def load_trails
    @trails = Trail.all.order('status DESC', :name)
  end

  def load_trail
    @trail = Trail.friendly.find(params[:id])
  end
end
