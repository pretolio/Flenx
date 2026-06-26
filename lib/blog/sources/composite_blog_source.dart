import '../models/blog_post.dart';
import 'blog_source.dart';

/// Agrega várias [BlogSource] em uma só (Markdown + banco + ...). Carrega todas
/// em paralelo, deduplica por `slug` (a PRIMEIRA fonte vence — defina a ordem
/// de prioridade ao montar) e ordena do mais novo para o mais antigo.
class CompositeBlogSource implements BlogSource {
  const CompositeBlogSource(this.sources);

  final List<BlogSource> sources;

  @override
  Future<List<BlogPost>> loadAll() async {
    final results = await Future.wait(sources.map((s) => s.loadAll()));
    final bySlug = <String, BlogPost>{};
    for (final list in results) {
      for (final post in list) {
        bySlug.putIfAbsent(post.slug, () => post);
      }
    }
    final posts = bySlug.values.toList();
    posts.sort((a, b) => b.date.compareTo(a.date));
    return posts;
  }
}
