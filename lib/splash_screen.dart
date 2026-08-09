

import 'package:flutter/material.dart';
import 'package:storio_app/view/login_screen.dart';

class StorioColors {
  static const Color primary = Color(0xFF1A437A);
  static const Color secondary = Color(0xFF58769E);
  static const Color deepSpace = Color(0xFF0D2340); // darker than primary, for background depth
  static const Color glow = Color(0xFFBFE0FF);
}

class StorioSplashScreen extends StatefulWidget {
  /// Called once the intro animation has finished playing.
  /// Hook your navigation (e.g. Navigator.pushReplacement) here.
  final VoidCallback? onFinished;

  const StorioSplashScreen({super.key, this.onFinished});

  @override
  State<StorioSplashScreen> createState() => _StorioSplashScreenState();
}

class _StorioSplashScreenState extends State<StorioSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _barsController;
  late final AnimationController _introController;
  late final AnimationController _dotsController;

  late final Animation<double> _wordmarkOpacity;
  late final Animation<Offset> _wordmarkSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  static const int _barCount = 4;
  static const Duration _barDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    // Story bars: fill one after another, looping like Instagram stories.
    _barsController = AnimationController(
      vsync: this,
      duration: _barDuration * _barCount,
    )..repeat();

    // Wordmark + tagline entrance.
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _wordmarkOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
    );
    _wordmarkSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
    ));

    _taglineOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.45, 0.8, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.45, 0.8, curve: Curves.easeOut),
    ));

    // Pulsing loading dots at the bottom.
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Optional: call onFinished after a few loops of the story bars,
    // simulating "app finished loading".
    Future.delayed(const Duration(milliseconds: 2600), () async{
      await checkLogin();

    });
  }
  Future<void> checkLogin() async {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

  }

  @override
  void dispose() {
    _barsController.dispose();
    _introController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              StorioColors.deepSpace,
              StorioColors.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- top story bars ----
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: _StoryBars(
                  controller: _barsController,
                  barCount: _barCount,
                  barDuration: _barDuration,
                ),
              ),

              // ---- center content ----
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _wordmarkOpacity,
                        child: SlideTransition(
                          position: _wordmarkSlide,
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, StorioColors.glow],
                            ).createShader(bounds),
                            child: const Text(
                              'Storio',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: _taglineOpacity,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: Text(
                            'BUILD YOUR SCHOOL\'S WEBSITE',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.6,
                              color: StorioColors.glow.withOpacity(0.65),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---- bottom loader ----
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    _LoadingDots(controller: _dotsController),
                    const SizedBox(height: 14),
                    Text(
                      'LOADING YOUR STORIES',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        color: Colors.white.withOpacity(0.28),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Instagram-story-style progress bars across the top of the screen.
/// [barCount] bars fill one at a time, in a loop, over [controller]'s
/// duration (which should equal barCount * barDuration).
class _StoryBars extends StatelessWidget {
  final AnimationController controller;
  final int barCount;
  final Duration barDuration;

  const _StoryBars({
    required this.controller,
    required this.barCount,
    required this.barDuration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Row(
            children: List.generate(barCount, (i) {
              final segment = 1 / barCount;
              final start = i * segment;
              final t = ((controller.value - start) / segment).clamp(0.0, 1.0);
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i == barCount - 1 ? 0 : 6),
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: t,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            colors: [
                              StorioColors.glow,
                              StorioColors.secondary,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

/// Three softly pulsing dots, staggered, used as a bottom-of-screen
/// "still loading" indicator.
class _LoadingDots extends StatelessWidget {
  final AnimationController controller;

  const _LoadingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final delay = i * 0.15;
            final t = (controller.value - delay) % 1.0;
            final beat = t < 0 ? 0.0 : (1 - (t - 0.4).abs() / 0.4).clamp(0.0, 1.0);
            final scale = 0.85 + (0.3 * beat);
            final opacity = 0.3 + (0.7 * beat);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.5),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: StorioColors.glow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

