import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EnergyCard extends StatelessWidget {
  final int energyLevel; // 0 = not set, 1-5
  final ValueChanged<int> onEnergySet;

  const EnergyCard({super.key, required this.energyLevel, required this.onEnergySet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AuraTheme.accent.withOpacity(0.08),
            AuraTheme.accent2.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: energyLevel > 0
              ? AuraTheme.accent.withOpacity(0.3)
              : AuraTheme.border,
        ),
      ),
      child: energyLevel == 0 ? _checkIn() : _energySet(),
    );
  }

  Widget _checkIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AuraTheme.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'MORNING CHECK-IN',
                style: TextStyle(color: AuraTheme.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'How\'s your energy today?',
          style: TextStyle(color: AuraTheme.textPrim, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          'AURA will build your day around your answer.',
          style: TextStyle(color: AuraTheme.textSec, fontSize: 13),
        ),
        const SizedBox(height: 20),

        // Energy buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            final levels = ['😴', '😐', '🙂', '⚡', '🔥'];
            final labels = ['Low', 'Fair', 'Good', 'High', 'Peak'];
            final colors = [
              AuraTheme.textMuted,
              const Color(0xFFF4A261),
              const Color(0xFF7EE8A2),
              AuraTheme.accent,
              const Color(0xFFF87171),
            ];
            return GestureDetector(
              onTap: () => onEnergySet(i + 1),
              child: Column(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: AuraTheme.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AuraTheme.border),
                    ),
                    child: Center(
                      child: Text(levels[i], style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(labels[i], style: TextStyle(
                    color: colors[i], fontSize: 10, fontWeight: FontWeight.w500,
                  )),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _energySet() {
    final levels = ['😴', '😐', '🙂', '⚡', '🔥'];
    final labels = ['Low energy', 'Fair energy', 'Good energy', 'High energy', 'Peak energy'];
    final messages = [
      'Gentle tasks scheduled. Rest is productive too.',
      'Starting slow — ramping up after lunch.',
      'Solid day ahead. Mix of deep and light work.',
      'Deep work blocks locked in. Make the most of it.',
      'Peak mode. Your hardest tasks go first today.',
    ];

    return Row(
      children: [
        Text(levels[energyLevel - 1], style: const TextStyle(fontSize: 40)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(labels[energyLevel - 1], style: const TextStyle(
                color: AuraTheme.textPrim, fontSize: 15, fontWeight: FontWeight.w700,
              )),
              const SizedBox(height: 4),
              Text(messages[energyLevel - 1], style: const TextStyle(
                color: AuraTheme.textSec, fontSize: 12, height: 1.4,
              )),
            ],
          ),
        ),
      ],
    );
  }
}
