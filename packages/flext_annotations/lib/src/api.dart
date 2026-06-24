/// Declara um endpoint de API (route handler) servido pelo backend do framework.
///
/// Métodos da classe anotados com nome de verbo HTTP (`get`, `post`, ...) viram
/// handlers; o code-gen produz a tabela de dispatch do servidor.
class Api {
  /// Caminho do endpoint. Ex: `/api/users/:id`.
  final String path;

  const Api(this.path);
}
