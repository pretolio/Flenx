import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import 'admin_embed.dart';

/// Página /admin: o shell de navegação (Flutter) ocupando a tela inteira,
/// como ilha interativa. Montada só com o kit Dart (sem HTML).
@client
class AdminPage extends StatelessComponent {
  const AdminPage({super.key});

  @override
  Component build(BuildContext context) {
    return const FlextFullscreen(AdminEmbed());
  }
}
