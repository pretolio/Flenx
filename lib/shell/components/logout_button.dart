import 'package:flutter/material.dart';

/// Botão "Sair" no rodapé da sidebar.
class LogoutButton extends StatelessWidget {
  const LogoutButton({this.onLogout, super.key});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.logout, color: scheme.error),
      title: Text('Sair', style: TextStyle(color: scheme.error)),
      onTap: () {
        onLogout?.call();
        final scaffold = Scaffold.maybeOf(context);
        if (scaffold?.hasDrawer ?? false) scaffold!.closeDrawer();
      },
    );
  }
}
