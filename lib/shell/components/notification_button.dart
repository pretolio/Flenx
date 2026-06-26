import 'package:flutter/material.dart';

import '../models/app_notification.dart';

/// Botão de notificações da top bar — ícone com badge da contagem não lida e
/// um menu suspenso listando as notificações.
class NotificationButton extends StatelessWidget {
  const NotificationButton({this.notifications = const [], super.key});

  final List<AppNotification> notifications;

  int get _unread => notifications.where((n) => !n.read).length;

  @override
  Widget build(BuildContext context) {
    const icon = Icon(Icons.notifications_outlined);
    return PopupMenuButton<void>(
      tooltip: 'Notificações',
      icon: _unread > 0 ? Badge.count(count: _unread, child: icon) : icon,
      itemBuilder: (context) {
        if (notifications.isEmpty) {
          return const [
            PopupMenuItem(enabled: false, child: Text('Sem notificações')),
          ];
        }
        return [
          for (final n in notifications)
            PopupMenuItem(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  n.read ? Icons.mark_email_read_outlined : Icons.circle,
                  size: n.read ? 20 : 12,
                  color: n.read ? null : Theme.of(context).colorScheme.primary,
                ),
                title: Text(n.title),
                subtitle: Text(n.message),
              ),
            ),
        ];
      },
    );
  }
}
