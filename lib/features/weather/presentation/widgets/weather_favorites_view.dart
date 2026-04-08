import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clima_en_vivo/features/weather/data/open_weather_service.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/open_weather_icon.dart';

class WeatherFavoritesView extends StatefulWidget {
  const WeatherFavoritesView({
    required this.repository,
    required this.currentCity,
    required this.onSelectCity,
    super.key,
  });

  final WeatherRepository repository;
  final String currentCity;
  final ValueChanged<String> onSelectCity;

  @override
  State<WeatherFavoritesView> createState() => _WeatherFavoritesViewState();
}

class _WeatherFavoritesViewState extends State<WeatherFavoritesView> {
  static final RegExp _cityInputPattern = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]+$');

  final List<String> _cities = [
    'Ciudad de México',
    'Guadalajara',
    'Monterrey',
    'Mérida',
    'Puebla',
  ];

  late Future<List<CurrentWeather>> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _futureFavorites = _loadFavorites();
  }

  Future<List<CurrentWeather>> _loadFavorites() {
    return Future.wait(
      _cities.map((city) async {
        final dashboard = await widget.repository.fetchDashboard(city);
        return dashboard.current;
      }),
    );
  }

  void _refresh() {
    setState(() {
      _futureFavorites = _loadFavorites();
    });
  }

  Future<void> _removeFavoriteCity(String city) async {
    if (_cities.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe quedar al menos una ciudad en favoritos.'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quitar favorito'),
          content: Text('¿Deseas quitar "$city" de favoritos?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Quitar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _cities.removeWhere(
          (savedCity) => savedCity.toLowerCase() == city.toLowerCase());
      _futureFavorites = _loadFavorites();
    });
  }

  bool _isValidCityInput(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && _cityInputPattern.hasMatch(trimmed);
  }

  Future<void> _addFavoriteCity() async {
    final controller = TextEditingController();

    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar favorito'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Ciudad'),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]'),
              ),
            ],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) =>
                Navigator.of(context).pop(controller.text.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );

    if (!mounted || selected == null || selected.isEmpty) {
      return;
    }

    if (!_isValidCityInput(selected)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo se permiten letras y espacios para la ciudad.'),
        ),
      );
      return;
    }

    final normalized = selected.toLowerCase();
    final alreadyExists = _cities.any(
      (city) => city.toLowerCase() == normalized,
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esa ciudad ya está en favoritos.'),
        ),
      );
      return;
    }

    try {
      await widget.repository.fetchDashboard(selected);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró la ciudad. Intenta con otro nombre.'),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _cities.add(selected);
      _futureFavorites = _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<List<CurrentWeather>>(
      future: _futureFavorites,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_off_outlined, size: 44),
                      const SizedBox(height: 10),
                      Text(
                        'No fue posible cargar ciudades favoritas.',
                        style: textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final cities = snapshot.data ?? const [];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Favoritos',
                    style: textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: _addFavoriteCity,
                  icon: const Icon(Icons.add),
                  tooltip: 'Agregar favorito',
                ),
                IconButton(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Actualizar favoritos',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Toca una ciudad para convertirla en tu vista principal.',
              style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < cities.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _FavoriteCityCard(
                  weather: cities[index],
                  selected: cities[index].city.toLowerCase() ==
                      widget.currentCity.toLowerCase(),
                  onTap: () => widget.onSelectCity(cities[index].city),
                  onRemove: () => _removeFavoriteCity(_cities[index]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FavoriteCityCard extends StatelessWidget {
  const _FavoriteCityCard({
    required this.weather,
    required this.selected,
    required this.onTap,
    required this.onRemove,
  });

  final CurrentWeather weather;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: selected ? const Color(0xFF2D3352) : const Color(0xFF252A43),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              OpenWeatherIcon(iconCode: weather.icon, size: 42),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.city,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      weather.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(0)}°',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'H ${weather.humidity}%',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                color: Colors.white70,
                tooltip: 'Quitar de favoritos',
              ),
              if (selected) ...[
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
