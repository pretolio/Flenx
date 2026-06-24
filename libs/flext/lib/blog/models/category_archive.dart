import 'blog_post.dart';
import 'category.dart';

/// Página de arquivo de uma categoria: a categoria + os posts que pertencem a ela.
class CategoryArchive {
  const CategoryArchive(this.category, this.posts);

  final Category category;
  final List<BlogPost> posts;
}
