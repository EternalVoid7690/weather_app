import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';

class WeatherAirView extends StatelessWidget {
  const WeatherAirView({required this.air, super.key});

  final AirQuality air;

  String get _aqiText {
    switch (air.aqi) {
      case 1:
        return 'Muy buena';
      case 2:
        return 'Buena';
      case 3:
        return 'Moderada';
      case 4:
        return 'Mala';
      default:
        return 'Muy mala';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF252A43),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(Icons.eco_outlined, color: colorScheme.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Calidad del aire',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Índice AQI: ${air.aqi}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _aqiText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _PollutantTile(name: 'PM2.5', value: air.pm25),
        _PollutantTile(name: 'PM10', value: air.pm10),
        _PollutantTile(name: 'CO', value: air.co),
        _PollutantTile(name: 'NO₂', value: air.no2),
        _PollutantTile(name: 'O₃', value: air.o3),
      ],
    );
  }
}

class _PollutantTile extends StatelessWidget {
  const _PollutantTile({required this.name, required this.value});

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card.outlined(
        color: const Color(0xFF252A43),
        child: ListTile(
          title: Text(name),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('${value.toStringAsFixed(1)} μg/m³'),
          ),
        ),
      ),
    );
  }
}
