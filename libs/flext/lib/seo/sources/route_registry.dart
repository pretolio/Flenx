import '../models/route_meta.dart';
import 'i_route_source.dart';

/// Agrega múltiplas [IRouteSource] (estáticas + dinâmicas) e resolve todas as
/// rotas do site num único conjunto deduplicado por `path`.
///
/// É a fonte única consumida por todos os geradores (sitemap, llms, robots) e,
/// futuramente, pelo roteamento web/app.
class RouteRegistry {
  const RouteRegistry(this.sources);

  final List<IRouteSource> sources;

  /// Resolve todas as fontes em paralelo e remove paths duplicados
  /// (a primeira ocorrência vence).
  Future<List<RouteMeta>> resolveAll() async {
    final resolved = await Future.wait(sources.map((s) => s.resolve()));
    final seen = <String>{};
    final out = <RouteMeta>[];
    for (final list in resolved) {
      for (final route in list) {
        if (seen.add(route.path)) out.add(route);
      }
    }
    return out;
  }

  /// Apenas rotas indexáveis (entram no sitemap).
  Future<List<RouteMeta>> indexable() async {
    final all = await resolveAll();
    return all.where((r) => !r.noindex).toList(growable: false);
  }

  /// Localiza o metadado de um caminho específico (para injeção no `<head>`).
  Future<RouteMeta?> find(String path) async {
    final all = await resolveAll();
    for (final r in all) {
      if (r.path == path) return r;
    }
    return null;
  }
}
