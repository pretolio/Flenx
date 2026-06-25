// GERADO por `dart run flext:bootstrap` — NÃO edite (está no .gitignore).
// Embute o admin (Flutter) como ilha. Sua config fica em admin_app.dart.
import 'package:flext/embed.dart';
import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

@Import.onWeb('admin_app.dart', show: [#AdminApp])
import 'admin_page.imports.dart' deferred as admin;

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
