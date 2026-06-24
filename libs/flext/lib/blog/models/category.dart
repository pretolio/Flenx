import '../utils/slugify.dart';

/// Categoria de blog — hierárquica como no WordPress (ex.: `Tutoriais/Flutter`).
/// O [segments] guarda os nomes; [slugPath] os slugs correspondentes.
class Category {
  Category(this.segments)
      : slugPath = segments.map(Slugify.call).toList(growable: false);

  /// Nomes legíveis da hierarquia (ex.: `['Tutoriais', 'Flutter']`).
  final List<String> segments;

  /// Slugs correspondentes (ex.: `['tutoriais', 'flutter']`).
  final List<String> slugPath;

  /// Nome exibido (último segmento).
  String get name => segments.last;

  /// Caminho da página de arquivo (ex.: `/blog/categoria/tutoriais/flutter`).
  String get path => '/blog/categoria/${slugPath.join('/')}';

  /// Chave única para deduplicação/igualdade.
  String get key => slugPath.join('/');

  @override
  bool operator ==(Object other) => other is Category && other.key == key;

  @override
  int get hashCode => key.hashCode;

  /// Cria a categoria a partir de uma string `A/B/C` do frontmatter.
  factory Category.parse(String raw) => Category(
        raw.split('/').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      );
}
