import '../blog_repository.dart';
import '../models/blog_post.dart';
import 'blog_source.dart';

/// Fonte de posts em **Markdown**: arquivos `.md` em uma pasta do filesystem.
/// Mantém o fluxo clássico do Flext (criar post = soltar um `.md`).
class MarkdownBlogSource implements BlogSource {
  const MarkdownBlogSource(
    this.directory, {
    this.repository = const BlogRepository(),
  });

  /// Pasta com os arquivos `.md` (ex.: `lib/content/blog`).
  final String directory;
  final BlogRepository repository;

  @override
  Future<List<BlogPost>> loadAll() => repository.loadAll(directory);
}
