import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/data/open_weather_service.dart';

class WeatherMapCard extends StatelessWidget {
  const WeatherMapCard({
    required this.city,
    required this.lat,
    required this.lon,
    super.key,
  });

  final String city;
  final double lat;
  final double lon;

  static const _zoom = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tileX = _lonToTileX(lon, _zoom);
    final tileY = _latToTileY(lat, _zoom);

    final mapUrl =
        'https://tile.openweathermap.org/map/temp_new/$_zoom/$tileX/$tileY.png?appid=${OpenWeatherService.publicApiKey}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mapa del clima', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '$city · capa de temperatura',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      mapUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2A3155), Color(0xFF1C223F)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.map_outlined, size: 36),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Z$_zoom',
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.place, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _lonToTileX(double longitude, int zoom) {
    final n = math.pow(2.0, zoom).toDouble();
    return ((longitude + 180.0) / 360.0 * n).floor();
  }

  int _latToTileY(double latitude, int zoom) {
    final n = math.pow(2.0, zoom).toDouble();
    final latRad = latitude * math.pi / 180.0;
    final y =
        (1.0 - math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) /
            2.0 *
            n;
    return y.floor();
  }
}
