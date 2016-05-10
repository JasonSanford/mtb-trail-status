class Weather
  class Forecast
    def initialize(forecast_obj)
      @obj = forecast_obj
    end

    def date
      Time.at(@obj.time).to_datetime
    end

    def low_temp
      @obj.temperatureMin.to_i
    end

    def high_temp
      @obj.temperatureMax.to_i
    end

    def summary
      @obj.summary
    end

    def icon
      @obj.icon
    end
  end

  def initialize(weather_json)
    @obj = JSON.parse(weather_json, object_class: OpenStruct)
  end

  def today
    @today ||= Forecast.new(@obj.daily.data[0])
  end

  def tomorrow
    @tomorrow ||= Forecast.new(@obj.daily.data[1])
  end

  def the_day_after_tomorrow
    @the_day_after_tomorrow ||= Forecast.new(@obj.daily.data[2])
  end
end
