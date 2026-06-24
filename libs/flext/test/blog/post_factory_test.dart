import 'package:flutter_test/flutter_test.dart';
import 'package:flext/blog/post_factory.dart';

void main() {
  group('PostFactory', () {
    test('constrói BlogPost a partir do frontmatter', () {
      final post = const PostFactory().build('meu-slug', (
        data: {
          'title': 'Meu Post',
          'description': 'resumo',
          'date': '2026-06-23',
          'author': 'Ana',
          'category': 'Tutoriais/Flutter',
          'tags': ['flutter', 'web'],
        },
        body: 'corpo markdown',
      ));

      expect(post.slug, 'meu-slug');
      expect(post.title, 'Meu Post');
      expect(post.path, '/blog/meu-slug');
      expect(post.date, DateTime(2026, 6, 23));
      expect(post.category!.slugPath, ['tutoriais', 'flutter']);
      expect(post.category!.path, '/blog/categoria/tutoriais/flutter');
      expect(post.tags.map((t) => t.slug), ['flutter', 'web']);
      expect(post.bodyMarkdown, 'corpo markdown');
      expect(post.draft, isFalse);
    });

    test('reconhece draft:true', () {
      final post = const PostFactory().build('x', (
        data: {'title': 'X', 'draft': true},
        body: '',
      ));
      expect(post.draft, isTrue);
    });
  });
}

