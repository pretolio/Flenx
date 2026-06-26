import '../../seo/models/route_meta.dart';
import '../../seo/sources/i_route_source.dart';
import '../blog.dart';
import 'blog_source.dart';

/// Fonte de rotas SEO do blog que **recarrega as fontes a cada resolução**.
/// Usada quando há posts em banco (criados pelo admin em runtime): o sitemap/
/// llms.txt refletem os posts atuais sem reiniciar o servidor.
class DynamicBlogRouteSource implements IRouteSource {
  const DynamicBlogRouteSource(this.sources);

  final List<BlogSource> sources;

  @override
  Future<List<RouteMeta>> resolve() async {
    final blog = await Blog.fromSources(sources);
    return blog.routeSource.resolve();
  }
}
