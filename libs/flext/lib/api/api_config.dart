/// Configuração base aplicada a todas as chamadas (middlewares padrão):
/// CORS, limites de paginação. Pensada para o usuário não precisar configurar.
class ApiConfig {
  const ApiConfig({
    this.corsOrigin = '*',
    this.defaultPerPage = 20,
    this.maxPerPage = 100,
  });

  final String corsOrigin;
  final int defaultPerPage;
  final int maxPerPage;
}
