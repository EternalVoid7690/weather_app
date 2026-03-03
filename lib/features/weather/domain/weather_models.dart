class CurrentWeather {
  const CurrentWeather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.lat,
    required this.lon,
  });

  final String city;
  final double temperature;
  final double feelsLike;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;
  final double lat;
  final double lon;
}

class ForecastItem {
  const ForecastItem({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
  });

  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
}

class AirQuality {
  const AirQuality({
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.co,
    required this.no2,
    required this.o3,
  });

  final int aqi;
  final double pm25;
  final double pm10;
  final double co;
  final double no2;
  final double o3;
}

class WeatherDashboard {
  const WeatherDashboard({
    required this.current,
    required this.forecast,
    required this.air,
  });

  final CurrentWeather current;
  final List<ForecastItem> forecast;
  final AirQuality air;
}
