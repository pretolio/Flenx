import 'models/blog_post.dart';
import 'models/category.dart';
import 'models/category_archive.dart';
import 'models/tag.dart';
import 'models/tag_archive.dart';
import 'models/taxonomy.dart';

/// Indexa os posts em categorias e tags, produzindo as páginas de arquivo.
/// Pura (sem disco) → fácil de testar.
class TaxonomyBuilder {
  const TaxonomyBuilder();

  Taxonomy build(List<BlogPost> posts) {
    final published = posts.where((p) => !p.draft).toList();
    return Taxonomy(categories: _categories(published), tags: _tags(published));
  }

  List<CategoryArchive> _categories(List<BlogPost> posts) {
    final map = <String, ({Category cat, List<BlogPost> posts})>{};
    for (final post in posts) {
      final c = post.category;
      if (c == null) continue;
      map.putIfAbsent(c.key, () => (cat: c, posts: [])).posts.add(post);
    }
    return map.values
        .map((e) => CategoryArchive(e.cat, e.posts))
        .toList(growable: false);
  }

  List<TagArchive> _tags(List<BlogPost> posts) {
    final map = <String, ({Tag tag, List<BlogPost> posts})>{};
    for (final post in posts) {
      for (final t in post.tags) {
        map.putIfAbsent(t.slug, () => (tag: t, posts: [])).posts.add(post);
      }
    }
    return map.values
        .map((e) => TagArchive(e.tag, e.posts))
        .toList(growable: false);
  }
}
