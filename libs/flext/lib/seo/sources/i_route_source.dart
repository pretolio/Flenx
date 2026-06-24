import '../models/route_meta.dart';

/// Contrato de uma fonte de rotas. Cada fonte sabe produzir a lista de
/// [RouteMeta] que representa — estáticas ou expandidas de dados dinâmicos.
///
/// Resolução é assíncrona porque rotas dinâmicas podem consultar banco/API.
abstract interface class IRouteSource {
  Future<List<RouteMeta>> resolve();
}
