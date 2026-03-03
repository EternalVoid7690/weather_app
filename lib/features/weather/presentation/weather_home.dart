import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/data/open_weather_service.dart';
import 'package:clima_en_vivo/features/weather/domain/weather_models.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/weather_air_view.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/weather_forecast_view.dart';
import 'package:clima_en_vivo/features/weather/presentation/widgets/weather_now_view.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key, WeatherRepository? repository})
      : _repository = repository;

  final WeatherRepository? _repository;

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late final WeatherRepository _repository;
  late Future<WeatherDashboard> _future;
  int _index = 0;
  String _city = 'Ciudad de México';

  @override
  void initState() {
    super.initState();
    _repository = widget._repository ?? OpenWeatherService();
    _future = _repository.fetchDashboard(_city);
  }

  void _reload() {
    setState(() {
      _future = _repository.fetchDashboard(_city);
    });
  }

  Future<void> _changeCity() async {
    final controller = TextEditingController(text: _city);

    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar ciudad'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Ciudad'),
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
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (!mounted || selected == null || selected.isEmpty) {
      return;
    }

    setState(() {
      _city = selected;
      _future = _repository.fetchDashboard(_city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ClimaCast',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              _city,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _changeCity,
            icon: const Icon(Icons.search),
            tooltip: 'Cambiar ciudad',
          ),
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1F34),
              Color(0xFF171B2E),
              Color(0xFF131729),
            ],
          ),
        ),
        child: FutureBuilder<WeatherDashboard>(
          future: _future,
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
                          const Icon(Icons.cloud_off, size: 44),
                          const SizedBox(height: 10),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _reload,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final dashboard = snapshot.data!;
            return IndexedStack(
              index: _index,
              children: [
                WeatherNowView(current: dashboard.current),
                WeatherForecastView(forecast: dashboard.forecast),
                WeatherAirView(air: dashboard.air),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sunny),
            label: 'Hoy',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_view_week_outlined),
            label: 'Pronóstico',
          ),
          NavigationDestination(
            icon: Icon(Icons.air),
            label: 'Aire',
          ),
        ],
      ),
    );
  }
}
