import 'package:flutter_test/flutter_test.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/weather_game_view.dart';

void main() {
  test('builds rainy challenge with umbrella as answer', () {
    final item = ForecastItem(
      date: DateTime(2026, 4, 13),
      tempMin: 17,
      tempMax: 22,
      description: 'lluvia ligera',
      icon: '10d',
    );

    final round = WeatherGameEngine.buildRound(item);

    expect(round.correctAnswer, 'Paraguas');
    expect(round.options, contains('Paraguas'));
    expect(round.options.length, greaterThanOrEqualTo(4));
    expect(round.prompt, contains('lluvia'));
  });

  test('builds heat challenge with water as answer', () {
    final item = ForecastItem(
      date: DateTime(2026, 4, 13),
      tempMin: 30,
      tempMax: 36,
      description: 'cielo despejado',
      icon: '01d',
    );

    final round = WeatherGameEngine.buildRound(item);

    expect(round.correctAnswer, 'Agua');
    expect(round.options.length, greaterThanOrEqualTo(4));
  });

  test('builds cold challenge with jacket as answer', () {
    final item = ForecastItem(
      date: DateTime(2026, 4, 13),
      tempMin: 4,
      tempMax: 9,
      description: 'nublado',
      icon: '03d',
    );

    final round = WeatherGameEngine.buildRound(item);

    expect(round.correctAnswer, 'Chaqueta');
    expect(round.options.length, greaterThanOrEqualTo(4));
  });
}
