import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../models/app_user.dart';
import 'notification_button.dart';
import 'profile_menu.dart';

/// Barra superior (sempre presente). Mostra o título, o botão de tema (opcional),
/// notificações e o menu de perfil expansível. Em layouts com drawer, o Scaffold
/// injeta automaticamente o botão de menu (hambúrguer) à esquerda.
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    required this.user,
    this.title = '',
    this.notifications = const [],
    this.onLogout,
    this.isDark = false,
    this.onToggleTheme,
    super.key,
  });

  final AppUser user;
  final String title;
  final List<AppNotification> notifications;
  final VoidCallback? onLogout;

  /// Estado atual do tema (escolhe o ícone do botão).
  final bool isDark;

  /// Se fornecido, mostra um botão para alternar claro/escuro.
  final VoidCallback? onToggleTheme;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        if (onToggleTheme != null)
          IconButton(
            tooltip: isDark ? 'Tema claro' : 'Tema escuro',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: onToggleTheme,
          ),
        NotificationButton(notifications: notifications),
        ProfileMenu(user: user, onLogout: onLogout),
        const SizedBox(width: 8),
      ],
    );
  }
}
