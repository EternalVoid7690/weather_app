import 'package:flutter/material.dart';

class OpenWeatherIcon extends StatelessWidget {
  const OpenWeatherIcon({
    required this.iconCode,
    this.size = 46,
    super.key,
  });

  final String iconCode;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = 'https://openweathermap.org/img/wn/$iconCode@2x.png';
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: ColoredBox(
        color: const Color(0xFF2B3150),
        child: SizedBox(
          width: size,
          height: size,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Icon(
                Icons.cloud_outlined,
                color: colorScheme.primary,
                size: size * 0.55,
              );
            },
          ),
        ),
      ),
    );
  }
}
