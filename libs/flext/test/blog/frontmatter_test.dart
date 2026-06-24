import 'package:flutter_test/flutter_test.dart';
import 'package:flext/blog/frontmatter_parser.dart';
import 'package:flext/blog/utils/slugify.dart';

void main() {
  group('FrontmatterParser', () {
    test('separa frontmatter YAML do corpo', () {
      const raw = '---\n'
          'title: Olá Mundo\n'
          'tags: [a, b]\n'
          '---\n'
          '# Corpo\n\ntexto';
      final parsed = const FrontmatterParser().parse(raw);

      expect(parsed.data['title'], 'Olá Mundo');
      expect(parsed.data['tags'], ['a', 'b']);
      expect(parsed.body, startsWith('# Corpo'));
    });

    test('sem frontmatter, retorna corpo inteiro', () {
      final parsed = const FrontmatterParser().parse('só corpo');
      expect(parsed.data, isEmpty);
      expect(parsed.body, 'só corpo');
    });
  });

  group('Slugify', () {
    test('remove acentos e normaliza', () {
      expect(Slugify.call('Tutoriais Flutter'), 'tutoriais-flutter');
      expect(Slugify.call('Programação Avançada!'), 'programacao-avancada');
    });
  });
}

