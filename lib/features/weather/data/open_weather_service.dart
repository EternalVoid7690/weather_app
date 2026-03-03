import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRepository {
  Future<WeatherDashboard> fetchDashboard(String city);
}

class OpenWeatherService implements WeatherRepository {
  OpenWeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const _apiKey = '358fc579ff54e7f436eced47bd1bef1e';

  @override
  Future<WeatherDashboard> fetchDashboard(String city) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Falta la API key de OpenWeatherMap. Ejecuta con --dart-define=OPENWEATHER_API_KEY=tu_api_key',
      );
    }

    final currentUri = Uri.parse(
      '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric&lang=es',
    );

    final currentResponse = await _client.get(currentUri);
    if (currentResponse.statusCode != 200) {
      throw Exception('No se pudo obtener el clima actual de $city');
    }

    final currentJson =
        jsonDecode(currentResponse.body) as Map<String, dynamic>;
    final current = _parseCurrent(currentJson);

    final forecastUri = Uri.parse(
      '$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric&lang=es',
    );
    final forecastResponse = await _client.get(forecastUri);

    if (forecastResponse.statusCode != 200) {
      throw Exception('No se pudo obtener el pronóstico de $city');
    }

    final forecastJson =
        jsonDecode(forecastResponse.body) as Map<String, dynamic>;
    final forecast = _parseForecast(forecastJson);

    final airUri = Uri.parse(
      '$_baseUrl/air_pollution?lat=${current.lat}&lon=${current.lon}&appid=$_apiKey',
    );
    final airResponse = await _client.get(airUri);

    if (airResponse.statusCode != 200) {
      throw Exception('No se pudo obtener la calidad del aire');
    }

    final airJson = jsonDecode(airResponse.body) as Map<String, dynamic>;
    final air = _parseAirQuality(airJson);

    return WeatherDashboard(current: current, forecast: forecast, air: air);
  }

  CurrentWeather _parseCurrent(Map<String, dynamic> json) {
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final coord = json['coord'] as Map<String, dynamic>;

    return CurrentWeather(
      city: (json['name'] as String?) ?? 'Ciudad',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      description: ((weather['description'] as String?) ?? '').toUpperCase(),
      humidity: (main['humidity'] as num).toInt(),
      windSpeed: (wind['speed'] as num).toDouble(),
      icon: (weather['icon'] as String?) ?? '01d',
      lat: (coord['lat'] as num).toDouble(),
      lon: (coord['lon'] as num).toDouble(),
    );
  }

  List<ForecastItem> _parseForecast(Map<String, dynamic> json) {
    final items = (json['list'] as List)
        .cast<Map<String, dynamic>>()
        .map(_parseForecastEntry)
        .toList();

    final byDay = <String, ForecastItem>{};

    for (final item in items) {
      final key =
          '${item.date.year}-${item.date.month.toString().padLeft(2, '0')}-${item.date.day.toString().padLeft(2, '0')}';
      byDay.putIfAbsent(key, () => item);
    }

    return byDay.values.take(5).toList();
  }

  ForecastItem _parseForecastEntry(Map<String, dynamic> entry) {
    final main = entry['main'] as Map<String, dynamic>;
    final weather = (entry['weather'] as List).first as Map<String, dynamic>;

    return ForecastItem(
      date: DateTime.parse(entry['dt_txt'] as String),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      description: (weather['description'] as String?) ?? '',
      icon: (weather['icon'] as String?) ?? '01d',
    );
  }

  AirQuality _parseAirQuality(Map<String, dynamic> json) {
    final item = (json['list'] as List).first as Map<String, dynamic>;
    final main = item['main'] as Map<String, dynamic>;
    final components = item['components'] as Map<String, dynamic>;

    return AirQuality(
      aqi: (main['aqi'] as num).toInt(),
      pm25: (components['pm2_5'] as num).toDouble(),
      pm10: (components['pm10'] as num).toDouble(),
      co: (components['co'] as num).toDouble(),
      no2: (components['no2'] as num).toDouble(),
      o3: (components['o3'] as num).toDouble(),
    );
  }

  @visibleForTesting
  static String get apiKey => _apiKey;

  static String get publicApiKey => _apiKey;
}
