import 'package:flutter/material.dart';

import '../models/activity_item.dart';
import '../models/dashboard_stat.dart';
import 'card_panel.dart';
import 'icon_chip.dart';
import 'stat_card.dart';

/// Dashboard pronto do Flext: saudação, indicadores ([stats]) e atividade
/// recente ([activity]). Genérico — você passa os dados e os textos.
class FlextDashboard extends StatelessWidget {
  const FlextDashboard({
    required this.stats,
    required this.activity,
    this.greeting = 'Olá 👋',
    this.subtitle = 'Aqui está um resumo de hoje.',
    this.activityTitle = 'Atividade recente',
    super.key,
  });

  final List<DashboardStat> stats;
  final List<ActivityItem> activity;
  final String greeting;
  final String subtitle;
  final String activityTitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800, color: scheme.onSurface)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [for (final s in stats) StatCard(stat: s)],
          ),
          const SizedBox(height: 24),
          CardPanel(
            title: activityTitle,
            child: Column(
              children: [
                for (final a in activity)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: IconChip(icon: a.icon),
                    title: Text(a.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface)),
                    subtitle: Text(a.subtitle,
                        style: TextStyle(color: scheme.onSurfaceVariant)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
