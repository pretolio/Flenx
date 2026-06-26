import 'dart:io';

/// Gera os entrypoints que o jaspr EXIGE no projeto (`main.server.dart` e
/// `main.client.dart`) a partir do seu `lib/main.dart`. São sempre iguais
/// (3 linhas chamando a lib), então ficam fora do controle de versão
/// (`.gitignore`) — você só mantém o `main.dart`.
///
/// Uso: `dart run flenx:bootstrap`  (rode uma vez após clonar o projeto).
///
/// Convenção: seu `lib/main.dart` deve expor `Future<void> runSite(ServerOptions)`.
void main() {
  const server = '''
// GERADO por `dart run flenx:bootstrap` — NÃO edite (está no .gitignore).
// O jaspr exige um entrypoint *.server.dart; seu código fica em main.dart.
import 'main.dart' as app;
import 'main.server.options.dart';

void main() => app.runSite(defaultServerOptions);
''';

  const client = '''
// GERADO por `dart run flenx:bootstrap` — NÃO edite (está no .gitignore).
// O jaspr exige um entrypoint *.client.dart (hidratação no navegador).
import 'package:flenx/app_client.dart';
import 'main.client.options.dart';

void main() => runFlenxClient(defaultClientOptions);
''';

  if (!File('lib/main.dart').existsSync()) {
    stderr.writeln('Erro: lib/main.dart não encontrado. Crie seu main.dart '
        'expondo `Future<void> runSite(ServerOptions options)` primeiro.');
    exitCode = 64;
    return;
  }

  File('lib/main.server.dart').writeAsStringSync(server);
  File('lib/main.client.dart').writeAsStringSync(client);
  stdout.writeln('Entrypoints gerados: lib/main.server.dart, lib/main.client.dart');

  // Admin (opcional): se existir a config em lib/views/admin/admin_app.dart
  // (uma classe Flutter `AdminApp` usando FlenxAdminApp), gera o wiring
  // `admin_page.dart` por você — é sempre igual, então fica no .gitignore.
  final adminApp = File('lib/views/admin/admin_app.dart');
  if (adminApp.existsSync()) {
    const adminPage = '''
// GERADO por `dart run flenx:bootstrap` — NÃO edite (está no .gitignore).
// Embute o admin (Flutter) como ilha. Sua config fica em admin_app.dart.
import 'package:flenx/embed.dart';
import 'package:flenx/flenx.dart';
import 'package:jaspr/jaspr.dart';

@Import.onWeb('admin_app.dart', show: [#AdminApp])
import 'admin_page.imports.dart' deferred as admin;

@client
class AdminPage extends StatelessComponent {
  const AdminPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxFullscreen(
      FlutterIsland(
        loadLibrary: admin.loadLibrary(),
        builder: () => admin.AdminApp(),
      ),
    );
  }
}
''';
    File('lib/views/admin/admin_page.dart').writeAsStringSync(adminPage);
    stdout.writeln('Admin gerado: lib/views/admin/admin_page.dart');
  }

  stdout.writeln('Pronto. Rode `jaspr serve`. (Edite só o conteúdo: main.dart, '
      'config/, views/, e admin_app.dart.)');
}
