import 'dart:math';

import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/open_weather_icon.dart';

class WeatherGameView extends StatefulWidget {
  const WeatherGameView({
    required this.current,
    required this.forecast,
    super.key,
  });

  final CurrentWeather current;
  final List<ForecastItem> forecast;

  @override
  State<WeatherGameView> createState() => _WeatherGameViewState();
}

class _WeatherGameViewState extends State<WeatherGameView> {
  final Random _random = Random();
  late WeatherGameRound _round;
  int _score = 0;
  int _streak = 0;
  int _roundsPlayed = 0;
  String? _selectedAnswer;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _round = _generateRound();
  }

  WeatherGameRound _generateRound() {
    final pool = <ForecastItem>[
      ForecastItem(
        date: DateTime.now(),
        tempMin: widget.current.temperature - 2,
        tempMax: widget.current.temperature + 2,
        description: widget.current.description,
        icon: widget.current.icon,
      ),
      ...widget.forecast,
    ];

    final item = pool[_random.nextInt(pool.length)];
    return WeatherGameEngine.buildRound(item);
  }

  void _submitAnswer(String answer) {
    if (_selectedAnswer != null) return;

    final correct = answer == _round.correctAnswer;
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = correct;
      _roundsPlayed += 1;
      if (correct) {
        _score += 10;
        _streak += 1;
      } else {
        _streak = 0;
      }
    });
  }

  void _nextRound() {
    setState(() {
      _round = _generateRound();
      _selectedAnswer = null;
      _isCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPad = MediaQuery.paddingOf(context).bottom + 74 + 16;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad),
      children: [
        Text(
          'Modo arcade del clima',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Un minijuego random para adivinar la mejor decisión según el tiempo.',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child:
                          const Icon(Icons.videogame_asset_outlined, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Puntaje total',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '$_score pts',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _nextRound,
                      icon: const Icon(Icons.casino_outlined),
                      label: const Text('Random'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _GameStatChip(
                        icon: Icons.local_fire_department_outlined,
                        label: 'Racha',
                        value: '$_streak',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _GameStatChip(
                        icon: Icons.flag_outlined,
                        label: 'Retos',
                        value: '$_roundsPlayed',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    OpenWeatherIcon(iconCode: _round.icon, size: 42),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _round.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _round.prompt,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 14),
                for (final option in _round.options)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _selectedAnswer == null
                            ? () => _submitAnswer(option)
                            : null,
                        icon: Icon(
                          _selectedAnswer == option
                              ? (_isCorrect == true
                                  ? Icons.check_circle
                                  : Icons.cancel)
                              : Icons.arrow_forward_ios,
                          size: 18,
                        ),
                        label: Text(option),
                      ),
                    ),
                  ),
                if (_selectedAnswer != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (_isCorrect == true
                              ? Colors.greenAccent
                              : Colors.orangeAccent)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (_isCorrect == true
                                ? Colors.greenAccent
                                : Colors.orangeAccent)
                            .withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isCorrect == true
                              ? '¡Bien jugado!'
                              : 'Casi. La mejor respuesta era ${_round.correctAnswer}.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(_round.tip),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _nextRound,
                      icon: const Icon(Icons.skip_next_outlined),
                      label: const Text('Siguiente reto'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WeatherGameRound {
  const WeatherGameRound({
    required this.title,
    required this.prompt,
    required this.correctAnswer,
    required this.options,
    required this.tip,
    required this.icon,
  });

  final String title;
  final String prompt;
  final String correctAnswer;
  final List<String> options;
  final String tip;
  final String icon;
}

class _GameStatChip extends StatelessWidget {
  const _GameStatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherGameEngine {
  static final Random _random = Random();

  static WeatherGameRound buildRound(ForecastItem item) {
    final description = item.description.toLowerCase();
    final averageTemp = (item.tempMin + item.tempMax) / 2;

    if (_isRainy(description)) {
      return _buildRound(
        title: 'Reto de lluvia',
        prompt:
            'Hay ${item.description} en camino. ¿Qué objeto te da ventaja para esta misión?',
        correctAnswer: 'Paraguas',
        options: ['Paraguas', 'Gafas de sol', 'Patineta', 'Cometa'],
        tip: 'Con lluvia conviene cubrirte y evitar superficies resbalosas.',
        icon: item.icon,
      );
    }

    if (averageTemp >= 30) {
      return _buildRound(
        title: 'Reto de calor',
        prompt:
            'La temperatura ronda ${averageTemp.toStringAsFixed(0)} °C. ¿Qué recurso te ayuda más a sobrevivir?',
        correctAnswer: 'Agua',
        options: ['Agua', 'Bufanda', 'Chocolate caliente', 'Cobija térmica'],
        tip: 'En calor intenso, hidratarse y buscar sombra es la mejor jugada.',
        icon: item.icon,
      );
    }

    if (averageTemp <= 12) {
      return _buildRound(
        title: 'Reto de frío',
        prompt:
            'El mapa marca un ambiente fresco. ¿Qué equipamiento suma más defensa?',
        correctAnswer: 'Chaqueta',
        options: ['Chaqueta', 'Helado', 'Sandalias', 'Toalla de playa'],
        tip: 'Con temperaturas bajas, usar capas ayuda a mantener el calor.',
        icon: item.icon,
      );
    }

    if (_isCloudy(description)) {
      return _buildRound(
        title: 'Reto nublado',
        prompt:
            'El cielo está ${item.description}. ¿Qué plan encaja mejor con esta partida?',
        correctAnswer: 'Salir a caminar',
        options: [
          'Salir a caminar',
          'Esquiar',
          'Encender calefacción máxima',
          'Usar traje de buzo'
        ],
        tip:
            'Cuando el clima está suave, una actividad ligera es una gran opción.',
        icon: item.icon,
      );
    }

    return _buildRound(
      title: 'Reto sorpresa',
      prompt:
          'El clima está tranquilo con ${item.description}. ¿Qué accesorio te prepara mejor para salir?',
      correctAnswer: 'Gorra',
      options: ['Gorra', 'Paraguas roto', 'Cobija', 'Botas de nieve'],
      tip:
          'Con tiempo estable, lo ideal es salir ligero pero protegido del sol.',
      icon: item.icon,
    );
  }

  static WeatherGameRound _buildRound({
    required String title,
    required String prompt,
    required String correctAnswer,
    required List<String> options,
    required String tip,
    required String icon,
  }) {
    final shuffledOptions = List<String>.from(options)..shuffle(_random);
    return WeatherGameRound(
      title: title,
      prompt: prompt,
      correctAnswer: correctAnswer,
      options: shuffledOptions,
      tip: tip,
      icon: icon,
    );
  }

  static bool _isRainy(String description) {
    return description.contains('lluvia') ||
        description.contains('rain') ||
        description.contains('tormenta') ||
        description.contains('storm') ||
        description.contains('chubasco');
  }

  static bool _isCloudy(String description) {
    return description.contains('nube') ||
        description.contains('nublado') ||
        description.contains('cloud');
  }
}
