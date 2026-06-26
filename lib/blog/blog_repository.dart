import 'dart:io';

import 'frontmatter_parser.dart';
import 'models/blog_post.dart';
import 'post_factory.dart';

/// Carrega posts de blog de uma pasta de arquivos `.md` no filesystem.
///
/// Executa apenas no servidor (usa `dart:io`). O nome do arquivo (sem `.md`)
/// é o slug padrão. Posts são ordenados do mais novo para o mais antigo.
class BlogRepository {
  const BlogRepository({
    this.parser = const FrontmatterParser(),
    this.factory = const PostFactory(),
  });

  final FrontmatterParser parser;
  final PostFactory factory;

  Future<List<BlogPost>> loadAll(String directory) async {
    final dir = Directory(directory);
    if (!dir.existsSync()) return const [];

    final posts = <BlogPost>[];
    final files = dir.listSync().whereType<File>().where((f) {
      final name = f.uri.pathSegments.last.toLowerCase();
      if (!name.endsWith('.md')) return false;
      // Ignora documentação e arquivos auxiliares (convenção: README, _, .).
      if (name == 'readme.md') return false;
      if (name.startsWith('_') || name.startsWith('.')) return false;
      return true;
    });

    for (final file in files) {
      final name = file.uri.pathSegments.last;
      final slug = name.substring(0, name.length - 3);
      final raw = await file.readAsString();
      posts.add(factory.build(slug, parser.parse(raw)));
    }

    posts.sort((a, b) => b.date.compareTo(a.date));
    return posts;
  }
}
