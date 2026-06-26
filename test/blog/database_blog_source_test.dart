import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/api/db_executor.dart';
import 'package:flenx/blog/mappers/blog_post_mapper.dart';
import 'package:flenx/blog/models/blog_post.dart';
import 'package:flenx/blog/models/category.dart';
import 'package:flenx/blog/models/tag.dart';
import 'package:flenx/blog/sources/composite_blog_source.dart';
import 'package:flenx/blog/sources/database_blog_source.dart';

void main() {
  group('BlogPostMapper', () {
    test('round-trip post ↔ linha de banco', () {
      final post = BlogPost(
        slug: 'novidade-g1',
        title: 'Manchete da notícia',
        subtitle: 'A linha-fina explica o lide',
        description: 'resumo',
        date: DateTime(2026, 6, 25),
        bodyMarkdown: '## Olá\n\nCorpo.',
        author: 'Redação',
        image: '/img/capa.jpg',
        category: Category(['Brasil', 'Economia']),
        tags: [Tag('mercado'), Tag('dólar')],
        draft: false,
        views: 42,
      );

      final row = const BlogPostMapper().toRow(post);
      expect(row['category'], 'Brasil/Economia');
      expect(row['tags'], 'mercado, dólar');
      expect(row['draft'], 0);

      // Simula valores vindos do banco em texto (como a API serializa).
      final back = const BlogPostMapper()
          .fromRow(row.map((k, v) => MapEntry(k, v?.toString())));
      expect(back.slug, 'novidade-g1');
      expect(back.subtitle, 'A linha-fina explica o lide');
      expect(back.category!.segments, ['Brasil', 'Economia']);
      expect(back.tags.map((t) => t.name), ['mercado', 'dólar']);
      expect(back.views, 42);
      expect(back.draft, isFalse);
    });
  });

  group('DatabaseBlogSource', () {
    test('lê posts inseridos no banco', () async {
      final db = InMemoryDbExecutor();
      await db.insert('blog_posts', const BlogPostMapper().toRow(BlogPost(
        slug: 'do-banco',
        title: 'Post do banco',
        description: '',
        date: DateTime(2026, 6, 20),
        bodyMarkdown: 'conteúdo',
      )));

      final posts = await DatabaseBlogSource(db).loadAll();
      expect(posts, hasLength(1));
      expect(posts.first.slug, 'do-banco');
      expect(posts.first.bodyMarkdown, 'conteúdo');
    });
  });

  group('CompositeBlogSource', () {
    test('mescla fontes, deduplica por slug (1ª vence) e ordena por data',
        () async {
      final dbA = InMemoryDbExecutor();
      await dbA.insert('blog_posts', const BlogPostMapper().toRow(BlogPost(
        slug: 'a',
        title: 'A (prioritário)',
        description: '',
        date: DateTime(2026, 1, 1),
        bodyMarkdown: '',
      )));
      final dbB = InMemoryDbExecutor();
      await dbB.insert('blog_posts', const BlogPostMapper().toRow(BlogPost(
        slug: 'a',
        title: 'A (ignorado)',
        description: '',
        date: DateTime(2025, 1, 1),
        bodyMarkdown: '',
      )));
      await dbB.insert('blog_posts', const BlogPostMapper().toRow(BlogPost(
        slug: 'b',
        title: 'B mais novo',
        description: '',
        date: DateTime(2026, 6, 1),
        bodyMarkdown: '',
      )));

      final posts = await CompositeBlogSource([
        DatabaseBlogSource(dbA),
        DatabaseBlogSource(dbB),
      ]).loadAll();

      expect(posts.map((p) => p.slug), ['b', 'a']); // ordenado desc por data
      expect(posts.firstWhere((p) => p.slug == 'a').title, 'A (prioritário)');
    });
  });
}
