import 'package:flutter/widgets.dart';

/// Indicador do dashboard (ex.: Posts, Leads, Visitas).
class DashboardStat {
  const DashboardStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
  });

  final IconData icon;
  final String label;
  final String value;
  final String trend;
}
