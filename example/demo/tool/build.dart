import 'dart:io';

import 'package:flenx/app.dart';
import 'package:flenx_demo/config/site_api.dart';
import 'package:flenx_demo/main.dart' show buildPhp;

/// Build do projeto numa só chamada: gera a API PHP (se ligada no `main.dart`
/// via `buildPhp`) e compila o app web/Dart (jaspr build).
///
/// Uso: `dart run tool/build.dart`
Future<void> main() async {
  if (buildPhp) {
    await const PhpApiGenerator().writeTo('build/php', apis, models: dbModels);
    stdout.writeln(
        '✓ API PHP gerada em build/php/ (${apis.length} endpoints + migrations.sql).');
  } else {
    stdout.writeln('• PHP desativado (buildPhp=false no main.dart).');
  }

  stdout.writeln('→ Compilando app web/Dart (jaspr build)...');
  final proc = await Process.start(
    'dart',
    ['pub', 'global', 'run', 'jaspr_cli:jaspr', 'build'],
    mode: ProcessStartMode.inheritStdio,
    runInShell: true,
  );
  exitCode = await proc.exitCode;
}
