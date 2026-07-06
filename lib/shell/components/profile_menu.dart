import 'package:flutter/material.dart';

import '../models/app_user.dart';
import 'user_avatar.dart';

/// Menu de perfil expansível na top bar: avatar que abre um popup com dados do
/// usuário e ações (Perfil, Configurações, Sair).
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    required this.user,
    this.onLogout,
    this.onProfile,
    this.onSettings,
    super.key,
  });

  final AppUser user;
  final VoidCallback? onLogout;
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Perfil',
      offset: const Offset(0, 48),
      icon: UserAvatar(user: user, radius: 16),
      onSelected: (value) => switch (value) {
        'profile' => onProfile?.call(),
        'settings' => onSettings?.call(),
        'logout' => onLogout?.call(),
        _ => null,
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatar(user: user, radius: 18),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        _item('profile', Icons.person_outline, 'Perfil'),
        _item('settings', Icons.settings_outlined, 'Configurações'),
        const PopupMenuDivider(),
        _item('logout', Icons.logout, 'Sair'),
      ],
    );
  }

  PopupMenuItem<String> _item(String value, IconData icon, String label) =>
      PopupMenuItem(
        value: value,
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
      );
}
