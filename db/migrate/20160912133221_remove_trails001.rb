class RemoveTrails001 < ActiveRecord::Migration
  def up
    trails_to_delete = ['Jetton Park', 'Rocky Branch Trail']

    Trail.where(name: trails_to_delete).each do |trail|
      trail.destroy
    end
  end
end
