class Trail < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::DateHelper

  extend FriendlyId
  friendly_id :slug

  SOURCE_TARHEEL_TRAILBLAZERS = 'tarheel'
  SOURCE_USNWC                = 'usnwc'

  COLOR_OPEN   = '#060'
  COLOR_CLOSED = '#900'

  validates_uniqueness_of :name, :slug, :display_name

  after_save :notify_subscribers

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
        path: trail_path(self),
        status: status,
        status_date_string: "#{time_ago_in_words updated_at} ago",
        has_geojson: geojson_url ? true : false,
        geojson_url: geojson_url,
        'marker-symbol' => 'bicycle',
        'marker-color' => (status == 'open' ? COLOR_OPEN : COLOR_CLOSED)
      }
    }
  end

private
  def notify_subscribers
    if status_changed?
      puts "Status changed from #{status_was} to #{status} for #{name}"
    end
  end
end
