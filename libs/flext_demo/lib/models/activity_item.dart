import 'package:flutter/widgets.dart';

/// Item da lista de atividade recente do dashboard.
class ActivityItem {
  const ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}
