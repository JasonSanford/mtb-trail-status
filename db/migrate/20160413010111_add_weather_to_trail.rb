class AddWeatherToTrail < ActiveRecord::Migration
  def change
    add_column :trails, :weather_json, :text
  end
end
