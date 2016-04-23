class Weather
  def initialize(weather_json)
    @obj = JSON.parse(weather_json, object_class: OpenStruct)
  end

  def valid?
    'maybe?'
  end
end
