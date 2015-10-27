class Trail < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::DateHelper

  extend FriendlyId
  friendly_id :slug

  SOURCE_TARHEEL_TRAILBLAZERS = 'tarheel'
  SOURCE_USNWC                = 'usnwc'

  validates_uniqueness_of :name, :slug, :display_name

  def display_name
    read_attribute(:display_name) || name
  end

  def geojson
    {
      id: id,
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [longitude, latitude]
      },
      properties: {
        name: name,
        display_name: display_name,
        path: geojson_url,
        status: status,
        status_date_string: "#{time_ago_in_words status_date} ago",
        has_geojson: geojson_url ? true : false,
        'marker-symbol' => 'bicycle'
      }
    }
  end
end
