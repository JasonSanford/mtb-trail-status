class CreateTrails < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.string    :name,      null: false
      t.string    :slug,      null: false
      t.float     :latitude,  null: false
      t.float     :longitude, null: false
      t.string    :source,    null: false
      t.string    :display_name
      t.string    :status
      t.datetime  :status_date
      t.string    :geojson_url

      t.timestamps null: false
    end
  end
end
