import 'package:flutter/material.dart';

import '../../models/activity_item.dart';
import '../../models/dashboard_stat.dart';
import 'widgets/card_panel.dart';
import 'widgets/icon_chip.dart';
import 'widgets/stat_card.dart';

/// View do dashboard: boas-vindas, indicadores e atividade recente. Recebe os
/// dados do [AdminViewModel] (MVVM) — não conhece estado nem regras.
class DashboardContent extends StatelessWidget {
  const DashboardContent({
    required this.stats,
    required this.activity,
    super.key,
  });

  final List<DashboardStat> stats;
  final List<ActivityItem> activity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Olá, Gabriel 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800, color: scheme.onSurface)),
          const SizedBox(height: 4),
          Text('Aqui está um resumo do seu site hoje.',
              style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [for (final s in stats) StatCard(stat: s)],
          ),
          const SizedBox(height: 24),
          CardPanel(
            title: 'Atividade recente',
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
