import 'package:flext/embed.dart';
import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

// O app admin (Flutter) é importado só na web, deferido (o servidor não importa
// Flutter). A config dele está em admin_app.dart.
@Import.onWeb('admin_app.dart', show: [#AdminApp])
import 'admin_page.imports.dart' deferred as admin;

/// Rota /admin: embute o [AdminApp] (FlextAdminApp da lib) como ilha Flutter
/// em tela cheia. Só plumbing — toda a config fica em admin_app.dart.
@client
class AdminPage extends StatelessComponent {
  const AdminPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlextFullscreen(
      FlutterIsland(
        loadLibrary: admin.loadLibrary(),
        builder: () => admin.AdminApp(),
      ),
    );
  }
}
