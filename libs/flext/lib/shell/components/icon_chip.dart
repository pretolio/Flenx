import 'package:flutter/material.dart';

/// Quadradinho colorido com ícone (usado em cards e listas do dashboard).
class IconChip extends StatelessWidget {
  const IconChip({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: primary, size: 22),
    );
  }
}
