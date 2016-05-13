class RemoveGeojsonUrlFromTrails < ActiveRecord::Migration
  def change
    remove_column :trails, :geojson_url, :string
  end
end
