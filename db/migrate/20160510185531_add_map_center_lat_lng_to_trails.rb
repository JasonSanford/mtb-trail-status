class AddMapCenterLatLngToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :map_center_latitude, :float
    add_column :trails, :map_center_longitude, :float
  end
end
