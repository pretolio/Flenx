import '../models/blog_post.dart';

/// Fonte de posts do blog. Abstrai DE ONDE os posts vêm — arquivos `.md`,
/// banco de dados, API externa, etc. O [Blog] agrega uma ou mais fontes,
/// então um mesmo site pode ter posts em Markdown **e** posts no banco.
///
/// Implementações: [MarkdownBlogSource], [DatabaseBlogSource],
/// [CompositeBlogSource].
abstract interface class BlogSource {
  /// Carrega todos os posts desta fonte (sem ordenar/deduplicar — isso é
  /// responsabilidade do agregador).
  Future<List<BlogPost>> loadAll();
}
