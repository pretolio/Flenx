import 'dart:io';

import 'package:flext/blog/blog_scaffold.dart';

/// Inicializa o conteúdo de um projeto que usa flext.
///
/// Uso (em qualquer projeto que dependa de flext):
///   dart run flext:init [--dir=lib/content/blog]
///
/// A pasta é, nesta ordem: `--dir=`, env `FLEXT_BLOG_DIR`, ou `content/blog`.
/// Cria a pasta com um post de boas-vindas publicado.
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
  stdout.writeln('Rode o servidor e acesse /blog. '
      'Novos posts: dart run flext:new_post "Título".');
}
