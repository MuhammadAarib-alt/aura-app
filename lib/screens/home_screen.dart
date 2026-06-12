import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/energy_card.dart';
import '../widgets/task_card.dart';
import '../widgets/stat_ring.dart';
import 'ai_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final GoogleSignInAccount user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  int _energyLevel = 0; // 0 = not set

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardTab(
        user: widget.user,
        energyLevel: _energyLevel,
        onEnergySet: (v) => setState(() => _energyLevel = v),
      ),
      const _PlanTab(),
      AIChatScreen(),
      const _InsightsTab(),
      _ProfileTab(user: widget.user),
    ];

    return Scaffold(
      backgroundColor: AuraTheme.bg,
      body: pages[_tab],
      bottomNavigationBar: _BottomNav(
        current: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ── Dashboard ──────────────────────────────────────────────────────────────────
class _DashboardTab extends StatelessWidget {
  final GoogleSignInAccount user;
  final int energyLevel;
  final ValueChanged<int> onEnergySet;

  const _DashboardTab({
    required this.user,
    required this.energyLevel,
    required this.onEnergySet,
  });

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting + ',',
                          style: const TextStyle(color: AuraTheme.textSec, fontSize: 14),
                        ),
                        Text(
                          user.displayName?.split(' ').first ?? 'there',
                          style: const TextStyle(
                            color: AuraTheme.textPrim,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Avatar
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AuraTheme.border, width: 2),
                    ),
                    child: ClipOval(
                      child: user.photoUrl != null
                          ? Image.network(user.photoUrl!)
                          : Container(
                              color: AuraTheme.card,
                              child: const Center(
                                child: Text('👤', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Date chip
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 20),
              child: Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                style: const TextStyle(color: AuraTheme.textMuted, fontSize: 13),
              ),
            ),
          ),

          // Energy check-in card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EnergyCard(
                energyLevel: energyLevel,
                onEnergySet: onEnergySet,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Stats row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Expanded(child: StatRing(label: 'Tasks', value: 0.65, count: '7/11', color: AuraTheme.accent)),
                  SizedBox(width: 12),
                  Expanded(child: StatRing(label: 'Focus hrs', value: 0.4, count: '2.4h', color: AuraTheme.accent2)),
                  SizedBox(width: 12),
                  Expanded(child: StatRing(label: 'Streak', value: 0.8, count: '4d', color: AuraTheme.accent3)),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Today's tasks header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's plan",
                    style: TextStyle(
                      color: AuraTheme.textPrim,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AuraTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AuraTheme.accent.withOpacity(0.2)),
                    ),
                    child: const Text(
                      'AI Generated',
                      style: TextStyle(color: AuraTheme.accent, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          // Task list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: TaskCard(task: _sampleTasks[i]),
              ),
              childCount: _sampleTasks.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  static final List<TaskItem> _sampleTasks = [
    TaskItem(title: 'Deep work: Product roadmap', time: '9:00 AM', energy: 'High', tag: 'Work', done: true),
    TaskItem(title: 'Reply to team messages', time: '11:00 AM', energy: 'Medium', tag: 'Work', done: true),
    TaskItem(title: 'Lunch break — step outside', time: '12:30 PM', energy: 'Rest', tag: 'Health', done: false),
    TaskItem(title: 'Review investor deck', time: '2:00 PM', energy: 'Medium', tag: 'Work', done: false),
    TaskItem(title: '10-min walk', time: '4:00 PM', energy: 'Rest', tag: 'Health', done: false),
    TaskItem(title: 'Evening wind-down', time: '9:00 PM', energy: 'Low', tag: 'Rest', done: false),
  ];
}

// ── Plan Tab ────────────────────────────────────────────────────────────────────
class _PlanTab extends StatelessWidget {
  const _PlanTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Plan', style: TextStyle(
              color: AuraTheme.textPrim, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5,
            )),
            const SizedBox(height: 4),
            const Text('Your week at a glance', style: TextStyle(color: AuraTheme.textSec, fontSize: 14)),
            const SizedBox(height: 28),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('📅', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    const Text('Weekly plan view', style: TextStyle(
                      color: AuraTheme.textPrim, fontSize: 18, fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 8),
                    const Text(
                      'Complete the morning check-in\nto generate your weekly plan.',
                      style: TextStyle(color: AuraTheme.textSec, fontSize: 14, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ── Insights Tab ────────────────────────────────────────────────────────────────
class _InsightsTab extends StatelessWidget {
  const _InsightsTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Insights', style: TextStyle(
              color: AuraTheme.textPrim, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5,
            )),
            const SizedBox(height: 4),
            const Text('Your energy patterns', style: TextStyle(color: AuraTheme.textSec, fontSize: 14)),
            const SizedBox(height: 24),
            _InsightTile(emoji: '🔥', title: 'Peak hours', value: '9–11 AM', sub: 'Your best deep work window'),
            _InsightTile(emoji: '😴', title: 'Rest deficit', value: '−42 min', sub: 'Average this week'),
            _InsightTile(emoji: '✅', title: 'Completion rate', value: '71%', sub: 'Up 12% from last week'),
            _InsightTile(emoji: '🏃', title: 'Movement', value: '3/7 days', sub: 'Goal: 5 days'),
          ],
        ),
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final String emoji, title, value, sub;
  const _InsightTile({required this.emoji, required this.title, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AuraTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuraTheme.border),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AuraTheme.textSec, fontSize: 12)),
                Text(value, style: const TextStyle(color: AuraTheme.textPrim, fontSize: 18, fontWeight: FontWeight.w700)),
                Text(sub, style: const TextStyle(color: AuraTheme.textMuted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Tab ─────────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  final GoogleSignInAccount user;
  const _ProfileTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AuraTheme.accent.withOpacity(0.4), width: 2),
                gradient: AuraTheme.accentGrad,
              ),
              child: ClipOval(
                child: user.photoUrl != null
                    ? Image.network(user.photoUrl!)
                    : const Center(child: Text('👤', style: TextStyle(fontSize: 36))),
              ),
            ),
            const SizedBox(height: 14),
            Text(user.displayName ?? '', style: const TextStyle(
              color: AuraTheme.textPrim, fontSize: 20, fontWeight: FontWeight.w700,
            )),
            Text(user.email, style: const TextStyle(color: AuraTheme.textSec, fontSize: 13)),
            const SizedBox(height: 32),
            _ProfileOption(icon: '🎯', label: 'Goals & Priorities'),
            _ProfileOption(icon: '🔔', label: 'Notifications'),
            _ProfileOption(icon: '🌙', label: 'Sleep Schedule'),
            _ProfileOption(icon: '💳', label: 'Upgrade to Pro'),
            _ProfileOption(icon: '📤', label: 'Sign Out', destructive: true),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final String icon, label;
  final bool destructive;
  const _ProfileOption({required this.icon, required this.label, this.destructive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AuraTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuraTheme.border),
      ),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 20)),
        title: Text(label, style: TextStyle(
          color: destructive ? Colors.redAccent : AuraTheme.textPrim,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        )),
        trailing: destructive ? null : const Icon(Icons.chevron_right, color: AuraTheme.textMuted, size: 18),
      ),
    );
  }
}

// ── Bottom Navigation ──────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: '⊞', label: 'Home'),
      _NavItem(icon: '📋', label: 'Plan'),
      _NavItem(icon: '✦', label: 'AI', isCta: true),
      _NavItem(icon: '📊', label: 'Insights'),
      _NavItem(icon: '◉', label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AuraTheme.surface,
        border: const Border(top: BorderSide(color: AuraTheme.border)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 28),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final active = i == current;

          if (item.isCta) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  height: 46,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: AuraTheme.accentGrad,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AuraTheme.accent.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(item.icon,
                      style: const TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ),
            );
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.icon,
                    style: TextStyle(fontSize: 20,
                      color: active ? AuraTheme.accent : AuraTheme.textMuted)),
                  const SizedBox(height: 3),
                  Text(item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? AuraTheme.accent : AuraTheme.textMuted,
                    )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String icon, label;
  final bool isCta;
  const _NavItem({required this.icon, required this.label, this.isCta = false});
}

// Task model
class TaskItem {
  final String title, time, energy, tag;
  final bool done;
  const TaskItem({required this.title, required this.time, required this.energy, required this.tag, required this.done});
}
