import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';

class StatRing extends StatelessWidget {
  final String label, count;
  final double value;
  final Color color;

  const StatRing({
    super.key,
    required this.label,
    required this.value,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AuraTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuraTheme.border),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 28,
            lineWidth: 4,
            percent: value.clamp(0.0, 1.0),
            center: Text(count,
              style: const TextStyle(color: AuraTheme.textPrim, fontSize: 11, fontWeight: FontWeight.w700)),
            progressColor: color,
            backgroundColor: color.withOpacity(0.1),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AuraTheme.textSec, fontSize: 11)),
        ],
      ),
    );
  }
}
