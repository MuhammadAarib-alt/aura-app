import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/home_screen.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  const TaskCard({super.key, required this.task});

  Color get _tagColor {
    switch (task.tag) {
      case 'Health': return const Color(0xFF7EE8A2);
      case 'Rest': return const Color(0xFFA78BFA);
      default: return AuraTheme.accent2;
    }
  }

  Color get _energyColor {
    switch (task.energy) {
      case 'High': return AuraTheme.accent;
      case 'Medium': return const Color(0xFFF4A261);
      case 'Rest': return const Color(0xFFA78BFA);
      default: return AuraTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.done
            ? AuraTheme.surface.withOpacity(0.5)
            : AuraTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: task.done ? AuraTheme.border.withOpacity(0.5) : AuraTheme.border,
        ),
      ),
      child: Row(
        children: [
          // Check circle
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.done ? AuraTheme.accent : Colors.transparent,
              border: Border.all(
                color: task.done ? AuraTheme.accent : AuraTheme.border,
                width: 1.5,
              ),
            ),
            child: task.done
                ? const Icon(Icons.check, size: 12, color: AuraTheme.bg)
                : null,
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: task.done ? AuraTheme.textMuted : AuraTheme.textPrim,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: task.done ? TextDecoration.lineThrough : null,
                    decorationColor: AuraTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(task.time, style: const TextStyle(color: AuraTheme.textMuted, fontSize: 11)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _energyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(task.energy,
                        style: TextStyle(color: _energyColor, fontSize: 10, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _tagColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(task.tag,
              style: TextStyle(color: _tagColor, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
