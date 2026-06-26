import 'dart:io';

import 'package:flext/blog/blog_scaffold.dart';

/// Cria a pasta do **blog** com um post de boas-vindas publicado. (Opcional —
/// só rode se o seu site terá blog.)
///
/// Uso (em qualquer projeto que dependa de flext):
///   dart run flext:blog_init [--dir=lib/content/blog]
///
/// A pasta é, nesta ordem: `--dir=`, env `FLEXT_BLOG_DIR`, ou `content/blog`.
void main(List<String> argv) {
  String? dirArg;
  for (final a in argv) {
    if (a.startsWith('--dir=')) dirArg = a.substring('--dir='.length);
  }
  final dir =
      dirArg ?? Platform.environment['FLEXT_BLOG_DIR'] ?? 'content/blog';

  final file = BlogScaffold(dir: dir).createWelcome();
  if (file == null) {
    stdout.writeln('$dir já existe — nada a fazer.');
    return;
  }
  stdout.writeln('Criado: ${file.path}');
  stdout.writeln('Adicione `blog: \'$dir\'` no FlextApp.run e acesse /blog. '
      'Novos posts: dart run flext:new_post "Título".');
}
