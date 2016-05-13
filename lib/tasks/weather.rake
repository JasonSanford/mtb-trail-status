desc 'Get weather for trails'
task weather: :environment do
  Trail.all.each do |trail|
    forecast = ForecastIO.forecast(trail.latitude, trail.longitude, {params: {exclude: 'minutely,hourly,alerts,flags'}})

    trail.update!(weather_json: forecast.to_json) if forecast
  end
end
