import 'api_action.dart';
import 'field.dart';
import 'http_method.dart';

/// Definição declarativa de um endpoint de API. A mesma definição vira um
/// handler Dart (runtime) ou um arquivo PHP (gerado).
class ApiEndpoint {
  const ApiEndpoint({
    required this.path,
    required this.actions,
    this.method = HttpMethod.post,
    this.fields = const [],
    this.requiresAuth = false,
  });

  /// Caminho (ex.: `/api/leads`).
  final String path;

  final HttpMethod method;

  /// Campos de entrada validados (middleware de validação).
  final List<Field> fields;

  /// Ações executadas em ordem.
  final List<ApiAction> actions;

  /// Exige token válido (middleware de auth: `Authorization: Bearer <token>`).
  final bool requiresAuth;

  /// Nome de arquivo PHP correspondente (ex.: `/api/leads` → `leads.php`).
  String get phpFileName {
    final seg = path.split('/').where((s) => s.isNotEmpty);
    return '${seg.isEmpty ? 'index' : seg.last}.php';
  }
}
