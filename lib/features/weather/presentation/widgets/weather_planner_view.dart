import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/open_weather_icon.dart';

class WeatherPlannerView extends StatelessWidget {
  const WeatherPlannerView({required this.forecast, super.key});

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

  bool _isRainy(String description) {
    final lower = description.toLowerCase();
    return lower.contains('lluvia') ||
        lower.contains('tormenta') ||
        lower.contains('chubasco') ||
        lower.contains('rain') ||
        lower.contains('storm');
  }

  bool _isCloudy(String description) {
    final lower = description.toLowerCase();
    return lower.contains('nube') ||
        lower.contains('nublado') ||
        lower.contains('cloud');
  }

  String _bestHourToGoOut(ForecastItem item) {
    final avg = (item.tempMin + item.tempMax) / 2;
    if (_isRainy(item.description)) {
      return '13:00';
    }
    if (avg >= 32) {
      return '20:00';
    }
    if (avg <= 10) {
      return '12:00';
    }
    return '10:00';
  }

  String _bestHourToRun(ForecastItem item) {
    final avg = (item.tempMin + item.tempMax) / 2;
    if (_isRainy(item.description)) {
      return '19:00';
    }
    if (avg >= 30) {
      return '06:30';
    }
    if (avg <= 10) {
      return '14:00';
    }
    return '07:30';
  }

  String _bestHourToDoLaundry(ForecastItem item) {
    if (_isRainy(item.description)) {
      return 'No recomendado';
    }
    if (_isCloudy(item.description)) {
      return '11:00';
    }
    return '10:00';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bottomPad = MediaQuery.paddingOf(context).bottom + 74 + 16;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad),
      children: [
        Text(
          'Planificador semanal',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Mejor hora estimada para salir, correr y lavar ropa.',
          style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        for (final item in forecast)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PlannerDayCard(
              dayLabel: _weekDays[item.date.weekday - 1],
              dateLabel:
                  '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}',
              item: item,
              goOutHour: _bestHourToGoOut(item),
              runHour: _bestHourToRun(item),
              laundryHour: _bestHourToDoLaundry(item),
            ),
          ),
      ],
    );
  }
}

class _PlannerDayCard extends StatelessWidget {
  const _PlannerDayCard({
    required this.dayLabel,
    required this.dateLabel,
    required this.item,
    required this.goOutHour,
    required this.runHour,
    required this.laundryHour,
  });

  final String dayLabel;
  final String dateLabel;
  final ForecastItem item;
  final String goOutHour;
  final String runHour;
  final String laundryHour;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: const Color(0xFF252A43),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                OpenWeatherIcon(iconCode: item.icon, size: 42),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$dayLabel • $dateLabel',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${item.tempMin.toStringAsFixed(0)}° / ${item.tempMax.toStringAsFixed(0)}°',
                    style: textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _PlannerItemRow(
              icon: Icons.explore_outlined,
              activity: 'Salir',
              hour: goOutHour,
            ),
            const SizedBox(height: 8),
            _PlannerItemRow(
              icon: Icons.directions_run,
              activity: 'Correr',
              hour: runHour,
            ),
            const SizedBox(height: 8),
            _PlannerItemRow(
              icon: Icons.local_laundry_service_outlined,
              activity: 'Lavar ropa',
              hour: laundryHour,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlannerItemRow extends StatelessWidget {
  const _PlannerItemRow({
    required this.icon,
    required this.activity,
    required this.hour,
  });

  final IconData icon;
  final String activity;
  final String hour;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            activity,
            style: textTheme.bodyMedium,
          ),
        ),
        Text(
          hour,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
