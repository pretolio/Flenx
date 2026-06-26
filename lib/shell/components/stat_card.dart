import 'package:flutter/material.dart';

import '../models/dashboard_stat.dart';
import 'icon_chip.dart';

/// Card de indicador do dashboard.
class StatCard extends StatelessWidget {
  const StatCard({required this.stat, super.key});

  final DashboardStat stat;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 248,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconChip(icon: stat.icon),
              Text(stat.trend,
                  style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5)),
            ],
          ),
          const SizedBox(height: 14),
          Text(stat.value,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface)),
          Text(stat.label, style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
