import 'category_archive.dart';
import 'tag_archive.dart';

/// Resultado da indexação taxonômica do blog: categorias e tags com seus posts.
class Taxonomy {
  const Taxonomy({required this.categories, required this.tags});

  final List<CategoryArchive> categories;
  final List<TagArchive> tags;
}
