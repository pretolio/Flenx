import 'package:jaspr/jaspr.dart';

import 'blog_route_source.dart';
import 'markdown_renderer.dart';
import 'models/blog_post.dart';
import 'models/taxonomy.dart';
import 'pages/archive_page.dart';
import 'pages/blog_index_page.dart';
import 'pages/blog_post_page.dart';
import 'pages/taxonomy_index_page.dart';
import 'sources/blog_source.dart';
import 'sources/composite_blog_source.dart';
import 'sources/markdown_blog_source.dart';
import 'taxonomy_builder.dart';

/// Facade do blog — ponto único de uso. Carrega os `.md`, monta a taxonomia,
/// expõe a fonte de rotas para o SEO e resolve qualquer caminho `/blog*` no
/// componente a ser renderizado. Cria um post = soltar um arquivo markdown.
class Blog {
  Blog._(this.posts, this.taxonomy);

  final List<BlogPost> posts;
  final Taxonomy taxonomy;
  final MarkdownRenderer _md = const MarkdownRenderer();

  /// Carrega o blog de uma pasta de arquivos markdown (no servidor).
  static Future<Blog> load(String directory) =>
      fromSource(MarkdownBlogSource(directory));

  /// Carrega o blog de UMA fonte qualquer (Markdown, banco, composta...).
  static Future<Blog> fromSource(BlogSource source) async {
    final posts = await source.loadAll();
    final taxonomy = const TaxonomyBuilder().build(posts);
    return Blog._(posts, taxonomy);
  }

  /// Carrega o blog de VÁRIAS fontes ao mesmo tempo (ex.: `.md` + banco).
  /// A ordem define a prioridade quando há `slug` repetido (a primeira vence).
  static Future<Blog> fromSources(List<BlogSource> sources) =>
      fromSource(CompositeBlogSource(sources));

  /// Fonte de rotas para registrar no RouteRegistry (sitemap/llms/SEO).
  BlogRouteSource get routeSource =>
      BlogRouteSource(posts: posts, taxonomy: taxonomy);

  List<BlogPost> get _published =>
      posts.where((p) => !p.draft).toList(growable: false);

  bool handles(String path) => path == '/blog' || path.startsWith('/blog/');

  /// Resolve o caminho no componente correspondente, ou `null` se não existir.
  /// [query] é o termo de busca (`/blog?q=...`) e [page] a página (`?page=N`).
  Component? pageFor(String path, {String? query, int page = 1}) {
    if (path == '/blog') {
      return BlogIndexPage(
        posts: _published,
        taxonomy: taxonomy,
        query: query,
        page: page,
      );
    }
    if (path == '/blog/categoria') {
      return TaxonomyIndexPage(
        title: 'Categorias',
        description: 'Todas as categorias do blog.',
        links: [
          for (final c in taxonomy.categories)
            (
              label: c.category.segments.join(' / '),
              path: c.category.path,
              count: c.posts.length,
            ),
        ],
      );
    }
    if (path == '/blog/tag') {
      return TaxonomyIndexPage(
        title: 'Tags',
        description: 'Todas as tags do blog.',
        links: [
          for (final t in taxonomy.tags)
            (label: '#${t.tag.name}', path: t.tag.path, count: t.posts.length),
        ],
      );
    }
    if (path.startsWith('/blog/categoria/')) {
      final key = path.substring('/blog/categoria/'.length);
      final archive = _first(
        taxonomy.categories.where((c) => c.category.key == key),
      );
      if (archive == null) return null;
      return ArchivePage(
        title: 'Categoria: ${archive.category.name}',
        description: 'Artigos em ${archive.category.name}.',
        posts: archive.posts,
        basePath: archive.category.path,
        page: page,
      );
    }
    if (path.startsWith('/blog/tag/')) {
      final slug = path.substring('/blog/tag/'.length);
      final archive = _first(taxonomy.tags.where((t) => t.tag.slug == slug));
      if (archive == null) return null;
      return ArchivePage(
        title: 'Tag: ${archive.tag.name}',
        description: 'Artigos com a tag ${archive.tag.name}.',
        posts: archive.posts,
        basePath: archive.tag.path,
        page: page,
      );
    }
    // /blog/<slug>
    final slug = path.substring('/blog/'.length);
    final post = _first(_published.where((p) => p.slug == slug));
    if (post == null) return null;
    return BlogPostPage(post: post, htmlBody: _md.toHtml(post.bodyMarkdown));
  }

  static T? _first<T>(Iterable<T> items) => items.isEmpty ? null : items.first;
}
