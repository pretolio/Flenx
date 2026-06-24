import '../seo/models/breadcrumb.dart';
import '../seo/models/change_freq.dart';
import '../seo/models/page_kind.dart';
import '../seo/models/route_meta.dart';
import '../seo/sources/i_route_source.dart';
import 'models/blog_post.dart';
import 'models/taxonomy.dart';

/// Converte o blog (posts + categorias + tags + índice) em [RouteMeta]s,
/// integrando o conteúdo markdown à camada SEO: cada item gera sozinho sua
/// entrada no sitemap, no llms.txt e seu JSON-LD.
class BlogRouteSource implements IRouteSource {
  const BlogRouteSource({required this.posts, required this.taxonomy});

  final List<BlogPost> posts;
  final Taxonomy taxonomy;

  @override
  Future<List<RouteMeta>> resolve() async {
    return [
      _index(),
      if (taxonomy.categories.isNotEmpty)
        _taxonomyIndex('/blog/categoria', 'Categorias',
            'Todas as categorias do blog.'),
      if (taxonomy.tags.isNotEmpty)
        _taxonomyIndex('/blog/tag', 'Tags', 'Todas as tags do blog.'),
      ...posts.where((p) => !p.draft).map(_post),
      ...taxonomy.categories.map((c) => _archive(
            path: c.category.path,
            title: 'Categoria: ${c.category.name}',
            count: c.posts.length,
            section: 'Categorias',
          )),
      ...taxonomy.tags.map((t) => _archive(
            path: t.tag.path,
            title: 'Tag: ${t.tag.name}',
            count: t.posts.length,
            section: 'Tags',
          )),
    ];
  }

  RouteMeta _index() => const RouteMeta(
        path: '/blog',
        title: 'Blog',
        description: 'Artigos, tutoriais e novidades.',
        kind: PageKind.collection,
        section: 'Blog',
        priority: 0.7,
        changeFreq: ChangeFreq.daily,
      );

  RouteMeta _taxonomyIndex(String path, String title, String description) =>
      RouteMeta(
        path: path,
        title: title,
        description: description,
        kind: PageKind.collection,
        section: 'Blog',
        priority: 0.4,
        changeFreq: ChangeFreq.weekly,
      );

  RouteMeta _post(BlogPost p) => RouteMeta(
        path: p.path,
        title: p.title,
        description: p.description,
        kind: PageKind.blogPost,
        section: 'Blog',
        image: p.image,
        author: p.author,
        datePublished: p.date,
        lastmod: p.date,
        priority: 0.8,
        changeFreq: ChangeFreq.weekly,
        keywords: p.tags.map((t) => t.name).toList(),
        breadcrumbs: [
          const Breadcrumb(name: 'Início', path: '/'),
          const Breadcrumb(name: 'Blog', path: '/blog'),
          if (p.category != null)
            Breadcrumb(name: p.category!.name, path: p.category!.path),
          Breadcrumb(name: p.title),
        ],
      );

  RouteMeta _archive({
    required String path,
    required String title,
    required int count,
    required String section,
  }) =>
      RouteMeta(
        path: path,
        title: title,
        description: '$count ${count == 1 ? 'artigo' : 'artigos'} em $title.',
        kind: PageKind.collection,
        section: section,
        priority: 0.5,
        changeFreq: ChangeFreq.weekly,
        breadcrumbs: [
          const Breadcrumb(name: 'Início', path: '/'),
          const Breadcrumb(name: 'Blog', path: '/blog'),
          Breadcrumb(name: title),
        ],
      );
}
