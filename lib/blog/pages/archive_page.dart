import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/blog_post.dart';
import '../utils/paginate.dart';
import 'pagination_nav.dart';
import 'post_card.dart';

/// Página de listagem genérica — usada pelo índice do blog e pelas páginas de
/// arquivo de categoria e de tag. Recebe título, descrição, posts e pagina.
class ArchivePage extends StatelessComponent {
  const ArchivePage({
    required this.title,
    required this.description,
    required this.posts,
    this.basePath,
    this.page = 1,
    this.perPage = 4,
    super.key,
  });

  final String title;
  final String description;
  final List<BlogPost> posts;

  /// Caminho base para montar os links de paginação (ex.: `/blog/tag/web`).
  final String? basePath;
  final int page;
  final int perPage;

  @override
  Component build(BuildContext context) {
    final slice = Paginate.of(posts, page: page, perPage: perPage);
    return section(classes: 'blog-archive', [
      header([
        h1([.text(title)]),
        p([.text(description)]),
      ]),
      if (slice.items.isEmpty)
        p(classes: 'blog-empty', [.text('Nenhum artigo ainda.')])
      else
        div(classes: 'post-list', [
          for (final post in slice.items) PostCard(post),
        ]),
      if (slice.totalPages > 1 && basePath != null)
        PaginationNav(
          current: slice.current,
          totalPages: slice.totalPages,
          href: (n) => '$basePath?page=$n',
        ),
    ]);
  }
}
