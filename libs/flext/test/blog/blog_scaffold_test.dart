import 'package:flext/blog/blog_scaffold.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlogScaffold.markdown', () {
    test('gera frontmatter com slug/data/tags e draft true', () {
      final md = const BlogScaffold().markdown(
        title: 'Olá Mundo Flext',
        category: 'Tutoriais/Início',
        tags: ['flutter', 'seo'],
        date: DateTime(2026, 1, 9),
      );
      expect(md, contains('title: Olá Mundo Flext'));
      expect(md, contains('date: 2026-01-09')); // zero à esquerda no mês/dia
      expect(md, contains('category: Tutoriais/Início'));
      expect(md, contains('tags: [flutter, seo]'));
      expect(md, contains('draft: true'));
      expect(md, contains('# Olá Mundo Flext'));
    });

    test('valores padrão quando só o título é informado', () {
      final md = const BlogScaffold()
          .markdown(title: 'Post Simples', date: DateTime(2026, 12, 25));
      expect(md, contains('category: Sem categoria'));
      expect(md, contains('author: Equipe Flext'));
      expect(md, contains('tags: []'));
      expect(md, contains('draft: true'));
    });

    test('draft:false e body custom (post publicado)', () {
      final md = const BlogScaffold().markdown(
        title: 'Publicado',
        date: DateTime(2026, 3, 1),
        draft: false,
        body: 'Conteúdo real aqui.',
      );
      expect(md, contains('draft: false'));
      expect(md, contains('Conteúdo real aqui.'));
    });
  });
}
