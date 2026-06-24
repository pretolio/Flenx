import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'admin_embed.dart';

/// Página /admin: demonstra o shell de navegação (sidebar + drawer + top bar)
/// como ilha Flutter ocupando a viewport inteira.
@client
class AdminPage extends StatelessComponent {
  const AdminPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(height: 100.vh, width: 100.percent, margin: Margin.zero),
      [const AdminEmbed()],
    );
  }
}
