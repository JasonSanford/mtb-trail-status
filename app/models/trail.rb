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

  has_many :alerts

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

  def url
    "http://mtbtrailstat.us/trails/#{slug}"
  end

private
  def notify_subscribers
    if status_changed?
      alerts.each do |alert|
        user  = alert.user
        trail = alert.trail

        if user.can_receive_texts?
          message = "#{trail.name} is now #{trail.status}. #{trail.url}"

          puts "Sending message to user id #{user.id} (#{user.phone_number}): '#{message}'"

          $twilio_client.messages.create(
            from: $twilio_phone_number,
            to:   user.phone_number,
            body: message
          )
        else
          puts "User id #{user.id} will not be sent text message for #{trail.name} because: ", user.reasons_for_not_receiving_texts
        end
      end
    end
  end
end
