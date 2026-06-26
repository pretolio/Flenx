import '../models/route_meta.dart';
import 'i_route_source.dart';

/// Fonte de rotas estáticas — páginas fixas conhecidas em tempo de build
/// (home, sobre, contato, etc.). Equivale às páginas do file-based routing.
class StaticRouteSource implements IRouteSource {
  const StaticRouteSource(this.routes);

  final List<RouteMeta> routes;

  @override
  Future<List<RouteMeta>> resolve() async => routes;
}
