import '../utils/slugify.dart';

/// Tag de blog — transversal e plana (várias por post), como no WordPress.
class Tag {
  Tag(this.name) : slug = Slugify.call(name);

  final String name;
  final String slug;

  /// Caminho da página de arquivo da tag (ex.: `/blog/tag/flutter`).
  String get path => '/blog/tag/$slug';

  @override
  bool operator ==(Object other) => other is Tag && other.slug == slug;

  @override
  int get hashCode => slug.hashCode;
}
