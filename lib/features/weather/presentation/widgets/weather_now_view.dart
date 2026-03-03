import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/open_weather_icon.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/weather_map_card.dart';

class WeatherNowView extends StatelessWidget {
  const WeatherNowView({required this.current, super.key});

  final CurrentWeather current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        current.city,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OpenWeatherIcon(iconCode: current.icon, size: 60),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${current.temperature.toStringAsFixed(1)} °C',
                        style: theme.textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  current.description,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE74694), Color(0xFF4F46E5)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricItem(
                          label: 'Viento',
                          value: '${current.windSpeed.toStringAsFixed(1)} m/s',
                          icon: Icons.air,
                        ),
                      ),
                      Expanded(
                        child: _MetricItem(
                          label: 'Sensación',
                          value: '${current.feelsLike.toStringAsFixed(1)} °C',
                          icon: Icons.thermostat,
                        ),
                      ),
                      Expanded(
                        child: _MetricItem(
                          label: 'Humedad',
                          value: '${current.humidity} %',
                          icon: Icons.water_drop_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        WeatherMapCard(city: current.city, lat: current.lat, lon: current.lon),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
