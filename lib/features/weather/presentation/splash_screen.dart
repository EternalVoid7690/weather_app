import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:clima_en_vivo/features/weather/presentation/weather_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _orbitController;
  late final AnimationController _dotsController;

  late final Animation<double> _bgFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _dotsFade;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _bgFade = CurvedAnimation(parent: _bgController, curve: Curves.easeIn);

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _titleFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _subtitleFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    );

    _dotsFade = CurvedAnimation(parent: _dotsController, curve: Curves.easeIn);

    _startSequence();
  }

  Future<void> _startSequence() async {
    await _bgController.forward();
    await _logoController.forward();
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _dotsController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const WeatherHome(),
        transitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _orbitController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1120),
      body: FadeTransition(
        opacity: _bgFade,
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    Color(0xFF2D1B6B),
                    Color(0xFF171B2E),
                    Color(0xFF0E1120),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
            // Animated orbiting particles
            AnimatedBuilder(
              animation: _orbitController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _OrbitPainter(_orbitController.value),
                  size: Size.infinite,
                );
              },
            ),
            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo icon
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF7C3AED),
                              Color(0xFF4F46E5),
                              Color(0xFF2563EB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED)
                                  .withValues(alpha: 0.5),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.cloud_outlined,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // App title
                  ClipRect(
                    child: SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: const Text(
                          'ClimaCast',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  ClipRect(
                    child: SlideTransition(
                      position: _subtitleSlide,
                      child: FadeTransition(
                        opacity: _subtitleFade,
                        child: const Text(
                          'Tu clima en tiempo real',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFB0ACCE),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 56),
                  // Loading dots
                  FadeTransition(
                    opacity: _dotsFade,
                    child: _LoadingDots(),
                  ),
                ],
              ),
            ),
            // Bottom branding
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _dotsFade,
                child: const Text(
                  'Powered by OpenWeather',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A5880),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Orbiting particles painter ──────────────────────────────────────────────

class _OrbitPainter extends CustomPainter {
  _OrbitPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.38;

    final orbits = [
      _OrbitParams(
          radius: 130, speed: 1.0, dotSize: 4, alpha: 0.18, offset: 0.0),
      _OrbitParams(
          radius: 175, speed: 0.6, dotSize: 3, alpha: 0.12, offset: 0.35),
      _OrbitParams(
          radius: 220, speed: 0.4, dotSize: 2.5, alpha: 0.08, offset: 0.7),
    ];

    for (final o in orbits) {
      // Draw orbit ring
      final ringPaint = Paint()
        ..color = Colors.white.withValues(alpha: o.alpha * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(Offset(cx, cy), o.radius, ringPaint);

      // Draw orbiting dot
      final angle =
          (progress * o.speed * 2 * math.pi) + (o.offset * 2 * math.pi);
      final dx = cx + o.radius * math.cos(angle);
      final dy = cy + o.radius * math.sin(angle);

      final dotPaint = Paint()
        ..color = Colors.white.withValues(alpha: o.alpha * 3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), o.dotSize, dotPaint);

      // Trailing glow
      final glowPaint = Paint()
        ..color = const Color(0xFF7C3AED).withValues(alpha: o.alpha * 1.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(dx, dy), o.dotSize * 1.8, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.progress != progress;
}

class _OrbitParams {
  const _OrbitParams({
    required this.radius,
    required this.speed,
    required this.dotSize,
    required this.alpha,
    required this.offset,
  });

  final double radius;
  final double speed;
  final double dotSize;
  final double alpha;
  final double offset;
}

// ── Animated loading dots ────────────────────────────────────────────────────

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((_controller.value - delay) % 1.0 + 1.0) % 1.0;
            final scale = 0.6 + 0.4 * math.sin(t * math.pi);
            final opacity = 0.3 + 0.7 * math.sin(t * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF7C3AED),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
