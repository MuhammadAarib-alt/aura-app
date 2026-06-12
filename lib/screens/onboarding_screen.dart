import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardSlide> _slides = [
    OnboardSlide(
      emoji: '🧠',
      gradient: [Color(0xFF7EE8A2), Color(0xFF5B8DEF)],
      tag: 'MEET AURA',
      title: 'Your AI that\nthinks like you',
      subtitle: 'Most apps manage your tasks. AURA manages your energy — the thing that actually determines what you get done.',
      bg: Color(0xFF0D1A14),
    ),
    OnboardSlide(
      emoji: '⚡',
      gradient: [Color(0xFF5B8DEF), Color(0xFFA78BFA)],
      tag: 'ENERGY FIRST',
      title: 'Plans built around\nhow you feel',
      subtitle: 'Every morning, tell AURA your energy level. It reshuffles your entire day — deep work when sharp, light tasks when foggy.',
      bg: Color(0xFF0D1020),
    ),
    OnboardSlide(
      emoji: '🍽️',
      gradient: [Color(0xFFF4A261), Color(0xFFEF5B5B)],
      tag: 'WHOLE HUMAN',
      title: 'Eat. Move.\nRest. Repeat.',
      subtitle: 'AURA watches your patterns and reminds you to nourish your body before hunger derails your focus.',
      bg: Color(0xFF1A110A),
    ),
    OnboardSlide(
      emoji: '📊',
      gradient: [Color(0xFFA78BFA), Color(0xFF5B8DEF)],
      tag: 'REAL INSIGHTS',
      title: 'See your best\nself emerge',
      subtitle: 'Weekly AI reports show your peak hours, energy patterns, and the habits that are actually moving the needle.',
      bg: Color(0xFF110D1A),
    ),
    OnboardSlide(
      emoji: '🚀',
      gradient: [Color(0xFF7EE8A2), Color(0xFFF4A261)],
      tag: 'GET STARTED',
      title: 'Ready to live\non your terms?',
      subtitle: 'Join thousands of people who stopped fighting their energy and started working with it.',
      bg: Color(0xFF0A1210),
      isLast: true,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _goToAuth();
    }
  }

  void _goToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AuthScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraTheme.bg,
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _slides.length,
            itemBuilder: (ctx, i) => _SlidePage(slide: _slides[i]),
          ),

          // Bottom controls
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AuraTheme.bg.withOpacity(0.95)],
                ),
              ),
              child: Column(
                children: [
                  // Dot indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AuraTheme.accent,
                      dotColor: AuraTheme.border,
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Next / Get Started button
                  GestureDetector(
                    onTap: _next,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _slides[_currentPage].gradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _slides[_currentPage].gradient.first.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _currentPage < _slides.length - 1 ? 'Continue' : 'Get Started',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Skip
                  if (_currentPage < _slides.length - 1) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _goToAuth,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AuraTheme.textSec,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final OnboardSlide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: slide.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Big emoji in glowing circle
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        slide.gradient.first.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                    border: Border.all(
                      color: slide.gradient.first.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(slide.emoji, style: const TextStyle(fontSize: 72)),
                  ),
                ),
              ).animate().scale(
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),

              const SizedBox(height: 48),

              // Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: slide.gradient.first.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: slide.gradient.first.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  slide.tag,
                  style: TextStyle(
                    color: slide.gradient.first,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Title
              Text(
                slide.title,
                style: const TextStyle(
                  color: AuraTheme.textPrim,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(
                begin: 0.2,
                end: 0,
                delay: 300.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                slide.subtitle,
                style: const TextStyle(
                  color: AuraTheme.textSec,
                  fontSize: 15,
                  height: 1.65,
                ),
              ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardSlide {
  final String emoji;
  final List<Color> gradient;
  final String tag;
  final String title;
  final String subtitle;
  final Color bg;
  final bool isLast;

  const OnboardSlide({
    required this.emoji,
    required this.gradient,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.bg,
    this.isLast = false,
  });
}
