import '../models/route_meta.dart';
import 'i_route_source.dart';

/// Esquema GENÉRICO para rotas dinâmicas (ex.: `/blog/:slug`, `/produtos/:id`)
/// gerarem sitemap/llms automaticamente.
///
/// O desenvolvedor fornece:
/// - [provider]: busca os dados (posts, produtos...) — pode ser DB/API.
/// - [build]: transforma cada item `T` no [RouteMeta] correspondente.
///
/// O framework expande tudo na resolução, sem o dev tocar em XML/markdown.
///
/// ```dart
/// DynamicRouteSource<Post>(
///   provider: () => postsRepository.all(),
///   build: (post) => RouteMeta(
///     path: '/blog/${post.slug}',
///     title: post.title,
///     description: post.excerpt,
///     lastmod: post.updatedAt,
///     kind: PageKind.blogPost,
///   ),
/// );
/// ```
class DynamicRouteSource<T> implements IRouteSource {
  const DynamicRouteSource({required this.provider, required this.build});

  /// Fornece os itens de dados (assíncrono — DB, API, arquivos).
  final Future<List<T>> Function() provider;

  /// Mapeia um item em sua rota com metadados.
  final RouteMeta Function(T item) build;

  @override
  Future<List<RouteMeta>> resolve() async {
    final items = await provider();
    return items.map(build).toList(growable: false);
  }
}
