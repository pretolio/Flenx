import 'package:flutter_test/flutter_test.dart';
import 'package:flext/blog/blog_route_source.dart';
import 'package:flext/blog/models/blog_post.dart';
import 'package:flext/blog/models/category.dart';
import 'package:flext/blog/models/tag.dart';
import 'package:flext/blog/taxonomy_builder.dart';

void main() {
  group('BlogRouteSource', () {
    test('gera índice + posts + arquivos de categoria/tag (sem rascunhos)',
        () async {
      final posts = [
        BlogPost(
          slug: 'post-a',
          title: 'Post A',
          description: 'd',
          date: DateTime(2026, 6, 23),
          bodyMarkdown: '',
          category: Category.parse('Tutoriais/Flutter'),
          tags: [Tag('flutter')],
        ),
        BlogPost(
          slug: 'rascunho',
          title: 'Rascunho',
          description: 'd',
          date: DateTime(2026, 6, 20),
          bodyMarkdown: '',
          draft: true,
        ),
      ];
      final taxonomy = const TaxonomyBuilder().build(posts);
      final source = BlogRouteSource(posts: posts, taxonomy: taxonomy);

      final routes = await source.resolve();
      final paths = routes.map((r) => r.path).toList();

      expect(paths, contains('/blog'));
      expect(paths, contains('/blog/post-a'));
      expect(paths, contains('/blog/categoria/tutoriais/flutter'));
      expect(paths, contains('/blog/tag/flutter'));
      expect(paths, isNot(contains('/blog/rascunho'))); // draft fora
    });
  });
}

