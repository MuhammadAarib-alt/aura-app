import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            seenOnboarding ? const AuthScreen() : const OnboardingScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );

    if (!seenOnboarding) {
      prefs.setBool('seen_onboarding', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraTheme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                gradient: AuraTheme.accentGrad,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AuraTheme.accent.withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const Center(
                child: Text('✦', style: TextStyle(fontSize: 44, color: Colors.white)),
              ),
            )
            .animate()
            .scale(duration: 700.ms, curve: Curves.easeOutBack)
            .then()
            .shimmer(duration: 800.ms, color: Colors.white.withOpacity(0.15)),

            const SizedBox(height: 20),

            const Text(
              'AURA',
              style: TextStyle(
                color: AuraTheme.textPrim,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

            const SizedBox(height: 6),

            const Text(
              'AI Life Manager',
              style: TextStyle(color: AuraTheme.textSec, fontSize: 14, letterSpacing: 0.5),
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

            const SizedBox(height: 60),

            // Loading dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) =>
                Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AuraTheme.accent),
                )
                .animate(delay: Duration(milliseconds: 800 + (i * 150)))
                .fadeIn(duration: 300.ms)
                .then(delay: 200.ms)
                .fadeOut(duration: 300.ms)
                .then()
                .fadeIn(duration: 300.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
