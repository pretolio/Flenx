import 'package:flutter/material.dart';

import '../models/app_user.dart';

/// Avatar do usuário — mostra a imagem se houver [AppUser.avatarUrl], senão
/// as iniciais. Reutilizado na sidebar e no menu de perfil.
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.user, this.radius = 20, super.key});

  final AppUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      backgroundImage: user.avatarUrl != null
          ? NetworkImage(user.avatarUrl!)
          : null,
      child: user.avatarUrl == null
          ? Text(user.initials, style: TextStyle(fontSize: radius * 0.8))
          : null,
    );
  }
}
