import 'dart:io';

import 'package:flenx/blog/blog_scaffold.dart';

/// Cria a pasta do **blog** com um post de boas-vindas publicado. (Opcional —
/// só rode se o seu site terá blog.)
///
/// Uso (em qualquer projeto que dependa de flenx):
///   dart run flenx:blog_init [--dir=lib/content/blog]
///
/// A pasta é, nesta ordem: `--dir=`, env `FLENX_BLOG_DIR`, ou `content/blog`.
void main(List<String> argv) {
  String? dirArg;
  for (final a in argv) {
    if (a.startsWith('--dir=')) dirArg = a.substring('--dir='.length);
  }
  final dir =
      dirArg ?? Platform.environment['FLENX_BLOG_DIR'] ?? 'content/blog';

  final file = BlogScaffold(dir: dir).createWelcome();
  if (file == null) {
    stdout.writeln('$dir já existe — nada a fazer.');
    return;
  }
  stdout.writeln('Criado: ${file.path}');
  stdout.writeln('Adicione `blog: \'$dir\'` no FlenxApp.run e acesse /blog. '
      'Novos posts: dart run flenx:new_post "Título".');
}
