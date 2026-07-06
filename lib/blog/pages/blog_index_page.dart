import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/blog_post.dart';
import '../models/taxonomy.dart';
import '../utils/paginate.dart';
import 'pagination_nav.dart';
import 'post_card.dart';

/// Índice do blog com **busca** (GET `/blog?q=`), **filtros** de categoria/tag
/// (chips) e seção **Mais acessados** (top por `views`). Tudo SSR, sem JS.
class BlogIndexPage extends StatelessComponent {
  const BlogIndexPage({
    required this.posts,
    required this.taxonomy,
    this.query,
    this.page = 1,
    this.perPage = 4,
    super.key,
  });

  final List<BlogPost> posts;
  final Taxonomy taxonomy;
  final String? query;
  final int page;
  final int perPage;

  bool get _searching => (query?.trim().isNotEmpty ?? false);

  List<BlogPost> get _filtered {
    final q = query?.trim().toLowerCase() ?? '';
    if (q.isEmpty) return posts;
    return posts.where((post) {
      final cat = post.category?.segments.join(' ').toLowerCase() ?? '';
      return post.title.toLowerCase().contains(q) ||
          post.description.toLowerCase().contains(q) ||
          cat.contains(q) ||
          post.tags.any((t) => t.name.toLowerCase().contains(q));
    }).toList();
  }

  List<BlogPost> get _popular {
    final list = [...posts]..sort((x, y) => y.views.compareTo(x.views));
    return list.take(3).toList();
  }

  @override
  Component build(BuildContext context) {
    final results = _filtered;
    final slice = Paginate.of(results, page: page, perPage: perPage);
    final showPopular =
        !_searching && slice.current == 1 && _popular.isNotEmpty;
    return section(classes: 'blog-archive', [
      header([
        h1([.text('Blog')]),
        p([.text('Artigos, tutoriais e novidades.')]),
      ]),
      _searchBar(),
      _filters(),
      if (showPopular) ...[
        h2(classes: 'blog-section-title', [.text('🔥 Mais acessados')]),
        div(classes: 'post-list', [
          for (final post in _popular) PostCard(post),
        ]),
        h2(classes: 'blog-section-title', [.text('Todos os artigos')]),
      ] else if (_searching)
        h2(classes: 'blog-section-title', [
          .text('Resultados para "${query!.trim()}" (${results.length})'),
        ]),
      if (slice.items.isEmpty)
        p(classes: 'blog-empty', [.text('Nenhum artigo encontrado.')])
      else
        div(classes: 'post-list', [
          for (final post in slice.items) PostCard(post),
        ]),
      if (slice.totalPages > 1)
        PaginationNav(
          current: slice.current,
          totalPages: slice.totalPages,
          href: _pageHref,
        ),
    ]);
  }

  String _pageHref(int n) {
    final q = query?.trim() ?? '';
    final qp = q.isEmpty ? '' : 'q=${Uri.encodeComponent(q)}&';
    return '/blog?${qp}page=$n';
  }

  Component _searchBar() => form(
    [
      Component.element(
        tag: 'input',
        attributes: {
          'type': 'search',
          'name': 'q',
          'placeholder': 'Buscar artigos…',
          'value': query ?? '',
          'class': 'blog-search-input',
          'aria-label': 'Buscar no blog',
        },
      ),
      button(
        [.text('Buscar')],
        classes: 'btn btn-primary',
        attributes: {'type': 'submit'},
      ),
    ],
    action: '/blog',
    attributes: const {'method': 'get', 'role': 'search'},
    classes: 'blog-search',
  );

  Component _filters() => div(classes: 'blog-filters', [
    if (taxonomy.categories.isNotEmpty) ...[
      span(classes: 'filter-label', [.text('Categorias:')]),
      for (final c in taxonomy.categories)
        a([.text(c.category.name)], href: c.category.path, classes: 'chip'),
    ],
    if (taxonomy.tags.isNotEmpty) ...[
      span(classes: 'filter-label', [.text('Tags:')]),
      for (final t in taxonomy.tags)
        a(
          [.text('#${t.tag.name}')],
          href: t.tag.path,
          classes: 'chip chip-tag',
        ),
    ],
  ]);
}
