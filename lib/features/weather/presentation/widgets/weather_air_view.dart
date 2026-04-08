import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';

class WeatherAirView extends StatelessWidget {
  const WeatherAirView({required this.air, super.key});

  final AirQuality air;

  String get _updatedLabel {
    final diff = DateTime.now().difference(air.measuredAt.toLocal());
    if (diff.inMinutes < 1) {
      return 'Actualizado hace menos de 1 min';
    }
    if (diff.inMinutes < 60) {
      return 'Actualizado hace ${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return 'Actualizado hace ${diff.inHours} h';
    }
    return 'Actualizado hace ${diff.inDays} d';
  }

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

  String get _aqiRecommendation {
    switch (air.aqi) {
      case 1:
        return 'Condiciones favorables. Puedes realizar actividades al aire libre.';
      case 2:
        return 'Calidad aceptable. Personas sensibles deben moderar esfuerzos intensos.';
      case 3:
        return 'Riesgo moderado. Reduce ejercicio al aire libre en horas pico.';
      case 4:
        return 'Calidad mala. Evita actividad física al aire libre prolongada.';
      default:
        return 'Calidad muy mala. Permanece en interiores y usa protección respiratoria.';
    }
  }

  Color get _aqiColor {
    switch (air.aqi) {
      case 1:
        return const Color(0xFF2ECC71);
      case 2:
        return const Color(0xFFF1C40F);
      case 3:
        return const Color(0xFFE67E22);
      case 4:
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF8E44AD);
    }
  }

  _PollutantLevel _pollutantLevel(
      {required String name, required double value}) {
    switch (name) {
      case 'PM2.5':
        if (value <= 12) {
          return _PollutantLevel('Buena', const Color(0xFF2ECC71));
        }
        if (value <= 35.4) {
          return _PollutantLevel('Moderada', const Color(0xFFF1C40F));
        }
        if (value <= 55.4) {
          return _PollutantLevel('Dañina', const Color(0xFFE67E22));
        }
        return _PollutantLevel('Muy dañina', const Color(0xFFE74C3C));
      case 'PM10':
        if (value <= 54) {
          return _PollutantLevel('Buena', const Color(0xFF2ECC71));
        }
        if (value <= 154) {
          return _PollutantLevel('Moderada', const Color(0xFFF1C40F));
        }
        if (value <= 254) {
          return _PollutantLevel('Dañina', const Color(0xFFE67E22));
        }
        return _PollutantLevel('Muy dañina', const Color(0xFFE74C3C));
      case 'NO₂':
        if (value <= 53) {
          return _PollutantLevel('Buena', const Color(0xFF2ECC71));
        }
        if (value <= 100) {
          return _PollutantLevel('Moderada', const Color(0xFFF1C40F));
        }
        if (value <= 360) {
          return _PollutantLevel('Dañina', const Color(0xFFE67E22));
        }
        return _PollutantLevel('Muy dañina', const Color(0xFFE74C3C));
      case 'O₃':
        if (value <= 100) {
          return _PollutantLevel('Buena', const Color(0xFF2ECC71));
        }
        if (value <= 160) {
          return _PollutantLevel('Moderada', const Color(0xFFF1C40F));
        }
        if (value <= 240) {
          return _PollutantLevel('Dañina', const Color(0xFFE67E22));
        }
        return _PollutantLevel('Muy dañina', const Color(0xFFE74C3C));
      case 'CO':
        if (value <= 4400) {
          return _PollutantLevel('Buena', const Color(0xFF2ECC71));
        }
        if (value <= 9400) {
          return _PollutantLevel('Moderada', const Color(0xFFF1C40F));
        }
        if (value <= 12400) {
          return _PollutantLevel('Dañina', const Color(0xFFE67E22));
        }
        return _PollutantLevel('Muy dañina', const Color(0xFFE74C3C));
      default:
        return _PollutantLevel('Sin datos', Colors.grey);
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
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _aqiColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _aqiColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    _aqiRecommendation,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _updatedLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _PollutantTile(
          name: 'PM2.5',
          value: air.pm25,
          level: _pollutantLevel(name: 'PM2.5', value: air.pm25),
        ),
        _PollutantTile(
          name: 'PM10',
          value: air.pm10,
          level: _pollutantLevel(name: 'PM10', value: air.pm10),
        ),
        _PollutantTile(
          name: 'CO',
          value: air.co,
          level: _pollutantLevel(name: 'CO', value: air.co),
        ),
        _PollutantTile(
          name: 'NO₂',
          value: air.no2,
          level: _pollutantLevel(name: 'NO₂', value: air.no2),
        ),
        _PollutantTile(
          name: 'O₃',
          value: air.o3,
          level: _pollutantLevel(name: 'O₃', value: air.o3),
        ),
      ],
    );
  }
}

class _PollutantLevel {
  const _PollutantLevel(this.label, this.color);

  final String label;
  final Color color;
}

class _PollutantTile extends StatelessWidget {
  const _PollutantTile({
    required this.name,
    required this.value,
    required this.level,
  });

  final String name;
  final double value;
  final _PollutantLevel level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card.outlined(
        color: const Color(0xFF252A43),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: level.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(name),
            ],
          ),
          subtitle: Text(level.label),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'μg/m³',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
