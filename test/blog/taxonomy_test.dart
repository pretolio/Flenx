import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/blog/models/blog_post.dart';
import 'package:flenx/blog/models/category.dart';
import 'package:flenx/blog/models/tag.dart';
import 'package:flenx/blog/taxonomy_builder.dart';

BlogPost _post(
  String slug, {
  Category? cat,
  List<String> tags = const [],
  bool draft = false,
}) => BlogPost(
  slug: slug,
  title: slug,
  description: 'd',
  date: DateTime(2026, 1, 1),
  bodyMarkdown: '',
  category: cat,
  tags: tags.map(Tag.new).toList(),
  draft: draft,
);

void main() {
  group('TaxonomyBuilder', () {
    final tax = const TaxonomyBuilder().build([
      _post('a', cat: Category.parse('Tutoriais/Flutter'), tags: ['x', 'y']),
      _post('b', cat: Category.parse('Tutoriais'), tags: ['x']),
      _post('c', cat: Category.parse('Novidades'), tags: ['z'], draft: true),
    ]);

    test('agrupa categorias (exclui rascunhos)', () {
      final keys = tax.categories.map((c) => c.category.key).toList();
      expect(keys, containsAll(['tutoriais/flutter', 'tutoriais']));
      expect(keys, isNot(contains('novidades'))); // rascunho excluído
    });

    test('agrupa tags com seus posts', () {
      final x = tax.tags.firstWhere((t) => t.tag.slug == 'x');
      expect(x.posts, hasLength(2)); // posts a e b
      final y = tax.tags.firstWhere((t) => t.tag.slug == 'y');
      expect(y.posts, hasLength(1));
      expect(tax.tags.any((t) => t.tag.slug == 'z'), isFalse); // rascunho
    });
  });
}
