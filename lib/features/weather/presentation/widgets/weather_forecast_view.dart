import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/open_weather_icon.dart';

class WeatherForecastView extends StatelessWidget {
  const WeatherForecastView({required this.forecast, super.key});

  final List<ForecastItem> forecast;

  static const _weekDays = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom + 74 + 16;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad),
      itemBuilder: (context, index) {
        final item = forecast[index];
        final day = _weekDays[item.date.weekday - 1];
        final dateLabel =
            '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}';
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tileColor: const Color(0xFF252A43),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: OpenWeatherIcon(iconCode: item.icon),
          title: Text('$day • $dateLabel', style: textTheme.titleMedium),
          subtitle: Text(
            item.description,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${item.tempMin.toStringAsFixed(0)}° / ${item.tempMax.toStringAsFixed(0)}°',
              style:
                  textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: forecast.length,
    );
  }
}
