import 'dart:io';

/// Gera os entrypoints que o jaspr EXIGE no projeto (`main.server.dart` e
/// `main.client.dart`) a partir do seu `lib/main.dart`. São sempre iguais
/// (3 linhas chamando a lib), então ficam fora do controle de versão
/// (`.gitignore`) — você só mantém o `main.dart`.
///
/// Uso: `dart run flext:bootstrap`  (rode uma vez após clonar o projeto).
///
/// Convenção: seu `lib/main.dart` deve expor `Future<void> runSite(ServerOptions)`.
void main() {
  const server = '''
// GERADO por `dart run flext:bootstrap` — NÃO edite (está no .gitignore).
// O jaspr exige um entrypoint *.server.dart; seu código fica em main.dart.
import 'main.dart' as app;
import 'main.server.options.dart';

void main() => app.runSite(defaultServerOptions);
''';

  const client = '''
// GERADO por `dart run flext:bootstrap` — NÃO edite (está no .gitignore).
// O jaspr exige um entrypoint *.client.dart (hidratação no navegador).
import 'package:flext/app_client.dart';
import 'main.client.options.dart';

void main() => runFlextClient(defaultClientOptions);
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
  stdout.writeln('Pronto. Rode `jaspr serve`. (Edite só o lib/main.dart.)');
}
