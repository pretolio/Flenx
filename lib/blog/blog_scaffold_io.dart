import 'dart:io';

import 'utils/slugify.dart';

/// Cria posts de blog já com o frontmatter padrão. A geração do conteúdo
/// (`markdown`) é pura (testável); `create` grava o arquivo.
class BlogScaffold {
  const BlogScaffold({this.dir = 'content/blog'});

  /// Pasta onde os posts são gravados.
  final String dir;

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// Monta o conteúdo Markdown + frontmatter (sem tocar no disco).
  String markdown({
    required String title,
    String category = 'Sem categoria',
    List<String> tags = const [],
    DateTime? date,
    String author = 'Equipe Flenx',
    String description =
        'TODO — resumo curto e atraente (até ~155 caracteres).',
    bool draft = true,
    String body = 'Escreva o conteúdo aqui em **Markdown**.',
  }) {
    final d = date ?? DateTime.now();
    final ds = '${d.year}-${_two(d.month)}-${_two(d.day)}';
    return '''---
title: $title
description: $description
date: $ds
author: $author
category: $category
tags: [${tags.join(', ')}]
draft: $draft
---

# $title

$body
''';
  }

  /// Cria `<dir>/<slug>.md`. Lança [FileSystemException] se já existir.
  File create({
    required String title,
    String category = 'Sem categoria',
    List<String> tags = const [],
    DateTime? date,
    String author = 'Equipe Flenx',
    String description =
        'TODO — resumo curto e atraente (até ~155 caracteres).',
    bool draft = true,
    String body = 'Escreva o conteúdo aqui em **Markdown**.',
  }) {
    final slug = Slugify.call(title);
    final file = File('$dir/$slug.md');
    if (file.existsSync()) {
      throw FileSystemException('Já existe', file.path);
    }
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      markdown(
        title: title,
        category: category,
        tags: tags,
        date: date,
        author: author,
        description: description,
        draft: draft,
        body: body,
      ),
    );
    return file;
  }

  /// Cria um post de boas-vindas publicado (usado pelo `flenx:blog_init`).
  /// Retorna `null` se já existir, sem lançar.
  File? createWelcome() {
    final slug = Slugify.call('Bem-vindo ao Flenx');
    if (File('$dir/$slug.md').existsSync()) return null;
    return create(
      title: 'Bem-vindo ao Flenx',
      category: 'Geral',
      tags: ['flenx', 'comecando'],
      description:
          'Seu blog em Flutter/Dart com SSR, SEO automático e Markdown.',
      draft: false,
      body:
          'Este é o seu primeiro post. Crie outros com '
          '`dart run flenx:new_post "Título"` e edite os arquivos em '
          '`content/blog/`.\n\n'
          'O frontmatter controla **título**, **categoria**, **tags** e '
          '**draft**. Posts com `draft: true` não aparecem em produção.',
    );
  }
}
