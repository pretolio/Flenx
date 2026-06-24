import 'dart:io';

import 'package:flext/blog/blog_scaffold.dart';

/// Cria um post de blog com o frontmatter já preenchido.
///
/// Uso (em qualquer projeto que dependa de flext):
///   dart run flext:new_post "Título do post" [Categoria/Sub] [tag1,tag2] [--dir=lib/content/blog]
///
/// A pasta de destino é, nesta ordem: `--dir=`, env `FLEXT_BLOG_DIR`,
/// ou o padrão `content/blog`. Cria `<dir>/<slug>.md` com `draft: true`.
void main(List<String> argv) {
  final dir = _dirArg(argv) ??
      Platform.environment['FLEXT_BLOG_DIR'] ??
      'content/blog';
  final args = argv.where((a) => !a.startsWith('--dir=')).toList();

  if (args.isEmpty) {
    stderr.writeln('Uso: dart run flext:new_post "Título" '
        '[Categoria] [tag1,tag2] [--dir=pasta]');
    exitCode = 64;
    return;
  }

  final title = args[0];
  final category = args.length > 1 ? args[1] : 'Sem categoria';
  final tags = args.length > 2
      ? args[2].split(',').map((t) => t.trim()).toList()
      : <String>[];

  try {
    final file = BlogScaffold(dir: dir)
        .create(title: title, category: category, tags: tags);
    stdout.writeln('Criado: ${file.path}');
    stdout.writeln('Edite o conteúdo e troque "draft: true" para publicar.');
  } on FileSystemException catch (e) {
    stderr.writeln('${e.message}: ${e.path}');
    exitCode = 1;
  }
}

String? _dirArg(List<String> argv) {
  for (final a in argv) {
    if (a.startsWith('--dir=')) return a.substring('--dir='.length);
  }
  return null;
}
