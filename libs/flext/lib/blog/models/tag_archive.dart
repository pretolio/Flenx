import 'blog_post.dart';
import 'tag.dart';

/// Página de arquivo de uma tag: a tag + os posts marcados com ela.
class TagArchive {
  const TagArchive(this.tag, this.posts);

  final Tag tag;
  final List<BlogPost> posts;
}
